//
//  Int+Livetouch.swift
//  AprovadorCorporativo
//
//  Created by livetouch PR on 10/6/15.
//  Copyright © 2015 Livetouch Brasil. All rights reserved.
//

import Foundation

public extension Int {
    
    func toCInt() -> CInt {
        let number : NSNumber = self as NSNumber
        let pos: CInt = number.int32Value
        return pos
    }
    
    func toHexString() -> String {
        return NSString(format:"%02x", self) as String
    }
    
    func toFloat() -> Float {
        return Float(self)
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}
