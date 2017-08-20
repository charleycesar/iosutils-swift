//
//  UIApplication+Livetouch.swift
//  Pods
//
//  Created by Guilherme Politta on 7/07/16.
//
//

import UIKit

public extension UIApplication {
    
    public static func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        if let menu = base as? SideMenuContainerViewController {
            return topViewController(menu.getCenterViewController())
        }
        
        return base
    }
}
