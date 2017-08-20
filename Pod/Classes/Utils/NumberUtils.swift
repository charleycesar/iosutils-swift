//
//  NumberUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 08/08/2016.
//
//

import UIKit

open class NumberUtils: NSObject {
    
    //MARK: - Int
    
    static open func toInteger(_ s: String?, withDefaultValue defaultValue: Int = 0) -> Int {
        guard let s = s , StringUtils.isNotEmpty(s) else {
            return defaultValue
        }
        
        guard let intString = Int(s) else {
            return defaultValue
        }
        
        return intString
    }
    
    //MARK: - Float
    
    static open func toFloat(_ s: String?, withDefaultValue defaultValue: Float = 0.0) -> Float {
        guard let s = s , StringUtils.isNotEmpty(s) else {
            return defaultValue
        }
        
        guard let floatString = Float(s) else {
            return defaultValue
        }
        
        return floatString
    }
    
    //MARK: - Double
    
    static open func toDouble(_ s: String?, withDefaultValue defaultValue: Double = 0.0) -> Double {
        guard let s = s , StringUtils.isNotEmpty(s) else {
            return defaultValue
        }
        
        guard let doubleString = Double(s) else {
            return defaultValue
        }
        
        return doubleString
    }
    
    //MARK: - Number
    
    static open func toNumber(_ s: String?, withDefaultValue defaultValue: Double = 0.0) -> NSNumber {
        guard let s = s , StringUtils.isNotEmpty(s) else {
            return NSNumber(value: defaultValue)
        }
        
        guard let numberString = NumberFormatter().number(from: s) else {
            return NSNumber(value: defaultValue)
        }
        
        return numberString
    }
    
    //MARK: - Verification
    
    static open func isNumber(_ str: String?) -> Bool {
        return StringUtils.isDigits(str)
    }
}
