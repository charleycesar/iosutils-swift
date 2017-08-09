//
//  TelefoneUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

open class TelefoneUtils: NSObject {
    
    //MARK: - Mask
    
    static open func unmask(_ phone: String?) -> String {
        guard let phone = phone , StringUtils.isNotEmpty(phone) else {
            return ""
        }
        
        var unmasked = phone
        unmasked = StringUtils.replace(unmasked, inQuery: " ", withReplacement: "")
        unmasked = StringUtils.replace(unmasked, inQuery: "-", withReplacement: "")
        unmasked = StringUtils.replace(unmasked, inQuery: "(", withReplacement: "")
        unmasked = StringUtils.replace(unmasked, inQuery: ")", withReplacement: "")
        unmasked = StringUtils.replace(unmasked, inQuery: "+", withReplacement: "")
        
        return unmasked
    }
    
    static open func mask(_ phone: String?) -> String {
        var text = unmask(phone)
        if (StringUtils.isEmpty(text)) {
            return ""
        }
        
        if (text.length > 1) {
            text = text.insertString(string: " ", atIndex: 2)
        }
        
        if ((text.length > 7) && (text.length < 12)) {
            text = text.insertString(string: "-", atIndex: 7)
        } else {
            if (text.length >= 12) {
                text = text.insertString(string: "-", atIndex: 8)
            }
        }
        
        if (text.length > 13) {
            return ""
        }
        
        return text
    }
    
    //MARK: - Validation
    
    static open func isValid(_ phone: String?) -> Bool {
        guard let phone = phone , StringUtils.isNotEmpty(phone) else {
            return false
        }
        
        let unmasked = unmask(phone)
        
        if (StringUtils.isNotDigits(unmasked)) {
            return false
        }
        
        let phoneArray = unmasked.split(separator: " ")
        
        if (phoneArray.count < 2) {
            return false
        }
        
        let ddd = phoneArray.count < 3 ? phoneArray[0] : phoneArray[1]
        if (ddd.length != 2) {
            return false
        }
        
        let phoneNumber = phoneArray.count < 3 ? phoneArray[1] : phoneArray[2]
        if (phoneNumber.length < 8) {
            return false
        }
        
        return true
    }
}
