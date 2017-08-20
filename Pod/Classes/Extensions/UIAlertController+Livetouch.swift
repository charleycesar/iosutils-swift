//
//  UIAlertController+Livetouch.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 17/06/2016.
//
//

import Foundation

public extension UIAlertController {
    
    public func show(_ animated: Bool = true) {
        
        guard let top = UIApplication.topViewController() else {
            return
        }
        
        top.present(self, animated: animated, completion: nil)
    }
}
