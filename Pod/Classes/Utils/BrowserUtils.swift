//
//  BrowserUtils.swift
//  Pods
//
//  Created by Livetouch on 11/07/16.
//
//

import UIKit

open class BrowserUtils: NSObject {
    
    static open func open(_ url: String?) {
        guard let url = url else {
            return
        }
        if let nsurl = URL(string: url) {
            UIApplication.shared.openURL(nsurl)
        }
    }

}
