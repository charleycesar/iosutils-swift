//
//  BusUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 20/06/2016.
//
//

import Foundation
import UIKit

open class NotificationUtils {
    
    //MARK: - Register
    
    static open func registerNotification(_ notificationName: String, withSelector selector: Selector, fromObserver observer: AnyObject) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
    
    //MARK: - Unregister
    
    static open func unregisterNotification(_ notificationName: String, fromObserver observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
    
    static open func unregisterAllNotificationsFromObserver(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    //MARK: - Post
    
    static open func postNotification(_ notificationName: String, withObject object: AnyObject? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationName), object: object)
    }
    
    static open func postNotification(_ notification: Notification) {
        NotificationCenter.default.post(notification)
    }
}
