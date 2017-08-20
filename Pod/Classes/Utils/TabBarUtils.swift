//
//  TabBarUtils.swift
//  Pods
//
//  Created by Livetouch BR on 6/23/16.
//
//

import UIKit

open class TabBarUtils: NSObject {

    static open func getHeight(_ viewController:UIViewController) -> CGFloat{
        
        guard let tabBarController = viewController.tabBarController else {
            return 0.0
        }
        
        let height = tabBarController.tabBar.frame.size.height
        
        return height
    }
    
    static open func setTextColor(_ color:UIColor){
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: color], for: UIControlState())
    }

    static open func setSelectedTextColor(_ color:UIColor){
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: color], for: .selected)
    }
    
    static open func setBackgroundColor(_ color:UIColor){
        UITabBar.appearance().barTintColor = color
    }
    
    static open func setSelectedBackgroundColor(_ color:UIColor, onNumberOfTabs numberOfTabs:CGFloat){
        UITabBar.appearance().selectionIndicatorImage = ImageUtils.getImageFromColor(color, whitRect: CGRect(x: 0, y: 0, width: DeviceUtils.getScreenWidth() / numberOfTabs , height: 49))
    }
}
