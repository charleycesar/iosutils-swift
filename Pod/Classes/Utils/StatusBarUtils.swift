//
//  StatusBarUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 20/06/2016.
//
//

import Foundation

open class StatusBarUtils: NSObject {
    
    //MARK: - Sizes
    
    static open func getHeight() -> CGFloat {
        let height = UIApplication.shared.statusBarFrame.size.height
        return height
    }
    
    //MARK: - Show & Hide
    
    static open func show() {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    static open func hide() {
        UIApplication.shared.isStatusBarHidden = true
    }
    
    static open func isHidden() -> Bool {
        return UIApplication.shared.isStatusBarHidden
    }
    
    //MARK: - Text Color
    
    static open func setTextColorToDefault() {
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    static open func setTextColorToWhite() {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    //MARK: - Background Color
    
    static open func setBackgroundToColor(_ color: UIColor) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: DeviceUtils.getScreenWidth(), height: 20))
        view.backgroundColor = color
        
        let window = UIApplication.shared.keyWindow
        if let window = window {
            window.rootViewController?.view.addSubview(view)
        }
    }
}
