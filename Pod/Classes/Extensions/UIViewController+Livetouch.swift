//
//  UIViewController+Livetouch.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 17/06/2016.
//
//

import Foundation

private var menuContainerAssociationKey: UInt8 = 1

public extension UIViewController {
    
    //MARK: - Menu
    
    fileprivate(set) public var menuContainerViewController: SideMenuContainerViewController? {
        get {
            var containerView : UIViewController? = self
            while (!(containerView is SideMenuContainerViewController) && containerView != nil) {
                containerView = containerView?.parent
                if (containerView == nil) {
                    containerView = containerView?.splitViewController
                }
            }
            return containerView as? SideMenuContainerViewController
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &menuContainerAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK: - Navigation Controller
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func popViewController(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    //MARK: - Open View Controller
    
    func openViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = menuContainerViewController?.getCenterViewController() as? UINavigationController else {
            return
        }
        
        navigationController.setViewControllers([viewController], animated: animated)
        menuContainerViewController?.setMenuState(.closed)
    }
}
