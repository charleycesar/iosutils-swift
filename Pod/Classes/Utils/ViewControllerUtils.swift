//
//  ViewControllerUtils.swift
//  Pods
//
//  Created by Livetouch BR on 6/23/16.
//
//

import UIKit

open class ViewControllerUtils: NSObject {
    
    static open func getAvailableScreenHeight(_ viewController:UIViewController) -> CGFloat {
        let statusBarHeight = StatusBarUtils.getHeight()
        let navigationBarHeight = NavigationBarUtils.getHeight(viewController)
        let tabBarHeight = NavigationBarUtils.getHeight(viewController)
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return 0.0
        }
        
        var availableHeight = keyWindow.frame.height
        availableHeight -= statusBarHeight + navigationBarHeight + tabBarHeight
        
        return availableHeight
    }
}
