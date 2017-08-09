//
//  LogUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 15/06/2016.
//
//

import UIKit

public enum LogTag {
    case log
    case debug
    case error
}

open class LogUtils: NSObject {
    
    static open func log(_ tag: String, message: String) {
        if message.isEmpty {
            return
        }
        if tag.isEmpty {
            return
        }
        
        print("[\(tag)]: \(message)")
    }
    
    static open func log(_ message: String) {
        if message.isEmpty {
            return
        }
        
        print("\(message)")
    }
    
    static open func debug(_ message: String) {
        if message.isEmpty {
            return
        }
        
        NSLog("Debug: %@", message)
    }
}
