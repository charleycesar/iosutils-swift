//
//  Array+Livetouch.swift
//  PedidoFacilV2-iOS
//
//  Created by livetouch PR on 7/7/15.
//  Copyright (c) 2015 livetouch. All rights reserved.
//

import Foundation

public extension Array {
    
    mutating func removeObject<U: Equatable>(_ object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                    break
                }
            }
        }
        
        if(index != nil) {
            self.remove(at: index!)
        }
    }
}

public extension Array where Element : AnyObject {
    
    public func toArrayDescription() -> [AnyObject] {
        return Array.toArrayDescription(self as NSArray)
    }
    
    static public func toArrayDescription(_ array: NSArray) -> [AnyObject] {
        var arrayRetorno: [AnyObject] = []
        for i in array {
            if (ClassUtils.isBasicClass(i)) {
                arrayRetorno.append(i as AnyObject)
            } else if let array = i as? NSArray {
                arrayRetorno.append(array)
            } else if let object = i as? NSObject {
                arrayRetorno.append(object.toDictionary() as AnyObject)
            }
        }
        
        return arrayRetorno
    }
}
