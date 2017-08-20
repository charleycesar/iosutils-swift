//
//  EmailUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 21/06/2016.
//
//

import UIKit

import MobileCoreServices
import MessageUI

public protocol EmailUtilsDelegate {
    func onEmailSuccessful()
    func onEmailCancelled()
    func onEmailFailed()
}

open class EmailUtils: NSObject, MFMailComposeViewControllerDelegate {
    
    //MARK: - Variables
    
    static var openEmail    : EmailUtils?
    
    var delegate : EmailUtilsDelegate?
    
    //MARK: - Valid
    
    static open func isValid(_ string: String?, withStrictRules strict: Bool = false) -> Bool {
        let emailRegex = strict ? "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$" : "^.+@.+\\.[A-Za-z]{2}[A-Za-z]*$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: string)
    }
    
    //MARK: - Send
    
    static open func canSendEmail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    static open func sendEmailTo(_ destinationEmail: String, withSubject subject: String = "", andBody body: String = "") {
        
        if !canSendEmail() {
            return
        }
        
        var email = "mailto:\(destinationEmail)"
        
        if (StringUtils.isNotEmpty(subject)) {
            email = "\(email)?subject=\(subject)"
        }
        
        if (StringUtils.isNotEmpty(body)) {
            email = "\(email)&body=\(body)"
        }
        
        if let addedPercent = email.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let nsurl = URL(string: addedPercent) {
                UIApplication.shared.openURL(nsurl)
            }
        }
    }
    
    static open func openEmailWithDelegate(_ delegate: EmailUtilsDelegate, presentInViewController viewController: UIViewController, withRecipients recipients: [String] = [], subject: String = "", body: String = "", isBodyHtml: Bool = false, attachments: [EmailAttachment] = []) -> EmailUtils? {
        
        if !canSendEmail() {
            return nil
        }
        
        let emailUtils = EmailUtils()
        emailUtils.delegate = delegate
        
        let mailCompose = MFMailComposeViewController()
        
        mailCompose.mailComposeDelegate = emailUtils
        mailCompose.setToRecipients(recipients)
        mailCompose.setSubject(subject)
        mailCompose.setMessageBody(body, isHTML: isBodyHtml)
        
        for attachment in attachments {
            mailCompose.addAttachmentData(attachment.getData() as Data, mimeType: attachment.getType(), fileName: attachment.getFilename())
        }
        
        viewController.present(mailCompose, animated: true, completion: nil)
        
        EmailUtils.openEmail = emailUtils
        
        return emailUtils
    }
    
    //MARK: - Mail Compose View Controller Delegate
    
    open func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
            case MFMailComposeResult.cancelled:
                delegate?.onEmailCancelled()
            
            case MFMailComposeResult.sent:
                delegate?.onEmailSuccessful()
            
            default:
                break
        }
        
        EmailUtils.openEmail = nil
        controller.dismiss(animated: true, completion: nil)
    }
}
