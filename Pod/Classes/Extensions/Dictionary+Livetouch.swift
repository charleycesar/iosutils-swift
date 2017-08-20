//
//  Dictionary+Livetouch.swift
//  AprovadorCorporativo
//
//  Created by livetouch PR on 10/6/15.
//  Copyright © 2015 Livetouch Brasil. All rights reserved.
//

import UIKit
import Foundation

public func ==(lhs: [String: AnyObject], rhs: [String: AnyObject] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public extension Dictionary {
    
    //MARK: - Debug Message Control
    
    static var SHOW_ERROR_MESSAGE : Bool {
        return false
    }
    
    //MARK: - Get Elements
    
    public func getBooleanWithKey(_ key: Key) -> Bool {
        if let parsedBoolean = self[key] as? Bool {
            return parsedBoolean
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - Bool - key: \(key)")
        }
        
        return false
    }
    
    public func getIntWithKey(_ key: Key) -> Int {
        if let parsedInt = self[key] as? Int {
            return parsedInt
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - Int - key: \(key)")
        }
        
        return 0
    }
    
    public func getUIntWithKey(_ key: Key) -> UInt {
        if let parsedUInt = self[key] as? UInt {
            return parsedUInt
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - UInt - key: \(key)")
        }
        
        return 0
    }
    
    public func getFloatWithKey(_ key: Key) -> Float {
        if let parsedFloat = self[key] as? Float {
            return parsedFloat
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - Float - key: \(key)")
        }
        
        return 0.0
    }
    
    public func getDoubleWithKey(_ key: Key) -> Double {
        if let parsedDouble = self[key] as? Double {
            return parsedDouble
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - Double - key: \(key)")
        }
        
        return 0.0
    }
    
    public func getStringWithKey(_ key: Key) -> String {
        if let parsedString = self[key] as? String {
            return parsedString
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - String - key: \(key)")
        }
        
        return ""
    }
    
    public func getDateWithKey(_ key: Key) -> Date {
        if let parsedDate = self[key] as? Date {
            return parsedDate
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - NSDate - key: \(key)")
        }
        
        return Date()
    }
    
    public func getArrayWithKey(_ key: Key) -> [AnyObject] {
        if let parsedArray = self[key] as? [AnyObject] {
            return parsedArray
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - Array - key: \(key)")
        }
        
        return []
    }
    
    public func getDictionaryWithKey(_ key: Key) -> [String: AnyObject] {
        if let parsedDictionary = self[key] as? [String: AnyObject] {
            return parsedDictionary
        }
        
        if Dictionary.SHOW_ERROR_MESSAGE {
            LogUtils.log("PARSE FAIL - Dictionary - key: \(key)")
        }
        
        return [:]
    }
    
    //MARK: - Conversoes
    
    public func toJsonString() throws -> String {
        guard let dictionary = self as? AnyObject else {
            return ""
        }
        
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return data.toString()
    }
}
