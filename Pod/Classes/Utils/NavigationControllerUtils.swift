//
//  NavigationControllerUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

open class NavigationControllerUtils: NSObject {
    
    //MARK: - Pop Gesture Recognizer
    
    static open func enableInteractivePopGesture(_ viewController: UIViewController?) {
        guard let navigationController = viewController?.navigationController else {
            return
        }
        
        if let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.isEnabled = true
        }
    }
    
    static open func disableInteractivePopGesture(_ viewController: UIViewController?) {
        guard let navigationController = viewController?.navigationController else {
            return
        }
        
        if let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.isEnabled = false
        }
    }
    
    //MARK: - Top View Controller
    
    static open func isTopViewController(_ viewController: UIViewController?) -> Bool {
        
        guard let viewController = viewController else {
            return false
        }
        
        let topViewController = getTopViewController()
        
        if (viewController.isEqual(topViewController)) {
            return true
        }
        
        return false
    }
    
    static open func getTopViewController() -> UIViewController? {
        return getApplicationTopViewControllerWithRootViewController(UIApplication.shared.keyWindow?.rootViewController)
    }
    
    static fileprivate func getApplicationTopViewControllerWithRootViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        if let container = rootViewController as? SideMenuContainerViewController {
            let centerViewController = container.getCenterViewController()
            return getApplicationTopViewControllerWithRootViewController(centerViewController)
            
        } else if let tabBarController = rootViewController as? UITabBarController {
            return getApplicationTopViewControllerWithRootViewController(tabBarController.selectedViewController)
            
        } else if let navigationController = rootViewController as? UINavigationController {
            return getApplicationTopViewControllerWithRootViewController(navigationController.visibleViewController)
            
        } else if let presentedViewController = rootViewController?.presentedViewController {
            return getApplicationTopViewControllerWithRootViewController(presentedViewController)
        }
        
        return rootViewController
    }
    
}
