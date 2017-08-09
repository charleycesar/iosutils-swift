//
//  LibWebViewController.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 23/06/2016.
//
//

import UIKit

///Classe que mostra nativamente uma página web passada.
open class LibWebViewController: LibBaseViewController, UIWebViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet var webView : UIWebView!
    
    @IBOutlet var progress : UIActivityIndicatorView!
    
    //MARK: - Variables
    
    open var url         : String!
    open var screenTitle : String?
    
    open var callbackError   : (() -> Void)?
    
    //MARK: - View Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let screenTitle = screenTitle {
            title = screenTitle
        } else {
            title = "Web"
        }
        
        progress.startAnimating()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nsurl = URL(string: url) {
            let request = URLRequest(url: nsurl)
            webView.loadRequest(request)
        }
    }
    
    //MARK: - Web View Delegate
    
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        progress.stopAnimating()
    }
    
    open func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        progress.stopAnimating()
        
        if let onError = callbackError {
            onError()
        }
        
        if error != nil {
            log(error.localizedDescription)
        }
    }
}
