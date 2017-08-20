//
//  AppleNotification.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 22/07/2016.
//
//

import UIKit

open class AppleNotification : NSObject {
    
    //MARK: - Variables
    
    open var dictionary   : [AnyHashable: Any]
    
    open var title        : String = ""
    open var body         : String = ""
    
    //MARK: - Inits
    
    public init(dictionary: [AnyHashable: Any]) {
        self.dictionary = dictionary;
        
        self.body = dictionary.getStringWithKey("body")
        self.title = dictionary.getStringWithKey("title")
    }
    
    //MARK: - Description
    
    override open var description: String {
        //TODO
        //let json = JSON.toJson(self)
        //return json
        return ""
    }
}
