//
//  PushNotification.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 22/07/2016.
//
//

import UIKit

open class PushNotification : NSObject {
    
    //MARK: - Variables
    
    static open var LOG_ON    : Bool = false
    
    open var collapseKey  : String = ""
    open var from         : String = ""
    
    fileprivate var userInfo    : [AnyHashable: Any] = [:]
    
    open var firebaseNotification : AppleNotification?
    open var appleNotification    : AppleNotification?
    
    //MARK: - Inits
    
    public init(userInfo: [AnyHashable: Any]) {
        super.init()
        
        if PushNotification.LOG_ON {
            LogUtils.log("PushNotification.parse() \(userInfo.description)")
        }
        
        collapseKey = userInfo.getStringWithKey("collapse_key")
        from = userInfo.getStringWithKey("from")
        self.userInfo = userInfo
        
        // Formato da Apple APNS
        if let apsDict = userInfo["aps"] as? [AnyHashable: Any] {
            if let alertDict = apsDict["alert"] as? [AnyHashable: Any] {
                appleNotification = AppleNotification(dictionary: alertDict as [NSObject : AnyObject])
                
                if PushNotification.LOG_ON {
                    LogUtils.log("PushNotification self.appleNotification: \(appleNotification)")
                }
            }
        }
        
        // Formato do Firebase
        if let notificationDict = userInfo["notification"] as? [AnyHashable: Any]{
            firebaseNotification = AppleNotification(dictionary: notificationDict as [NSObject : AnyObject])
            
            if PushNotification.LOG_ON {
                LogUtils.log("PushNotification self.firebaseNotification: \(firebaseNotification)")
            }
        }
    }
    
    //MARK: - Description
    //TODO
    override open var description: String {
        //let json = JSON.toJson(self)
        //return json
        return ""
    }
    
    //MARK: - Getters
    
    open func getTitle() -> String {
        
        if let appleNotification = appleNotification {
            return appleNotification.title
        }
        
        if let firebaseNotification = firebaseNotification {
            return firebaseNotification.title
        }
        
        return ""
    }
    
    open func getBody() -> String {
        
        if let appleNotification = appleNotification {
            return appleNotification.body
        }
        
        if let firebaseNotification = firebaseNotification {
            return firebaseNotification.body
        }
        
        return ""
    }
    
    open func getUserInfo() -> [AnyHashable: Any] {
        return userInfo
    }
}
