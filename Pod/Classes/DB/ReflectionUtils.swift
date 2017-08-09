//
//  ReflectionUtils.swift
//  SugarIOS
//
//  Created by Livetouch on 08/06/16.
//  Copyright © 2016 Livetouch. All rights reserved.
//

import UIKit

open class ReflectionUtils: NSObject {
    
    static open func getClassName(_ cls: AnyClass) -> String {
        let s = NSStringFromClass(cls).components(separatedBy: ".").last!
        return s;
    }
    
    static open func setFieldValue(_ object: NSObject, fieldName: String, value: AnyObject) {
        let mirror = Mirror(reflecting: object)
        if let properties = AnyBidirectionalCollection(mirror.children) {
            for property in properties {
                if(property.label == fieldName) {
                    SQLiteUtils.setValue(value, withName: fieldName, andObject: object)
                    return
                }
            }
        }
    }
    
    //TODO: Tentar voltar o tipo correto. (Int, String, etc..)
    static open func getFieldValue(_ object: NSObject, fieldName: String) -> NSObject {
        let mirror = Mirror(reflecting: object)
        
        guard let properties = AnyBidirectionalCollection(mirror.children) else {
            return "" as NSObject
        }
        
        for property in properties {
            if(property.label == fieldName) {
                // http://blog.krzyzanowskim.com/2015/11/19/swift-reflection-about-food/
                return String(describing: property.value) as NSObject
            }
        }
        
        return "" as NSObject
    }
    
    //TODO: Não usar, ainda em testes
    static fileprivate func TESTEgetFieldValue(_ object: NSObject, fieldName: String) -> Any? {
        let mirror = Mirror(reflecting: object)
        
        guard let properties = AnyBidirectionalCollection(mirror.children) else {
            return nil
        }
        
        for property in properties {
            if(property.label == fieldName) {
                // http://blog.krzyzanowskim.com/2015/11/19/swift-reflection-about-food/
                return property.value
            }
        }
        
        return nil
    }
    
    static open func getFields(_ cls: AnyClass) -> [Field] {
        
        var fields : [Field] = []
        
        // gambi pois nao pega atributo da superclasse
        if cls.superclass() is Entity.Type {
            let f = Field()
            f.name = "id";
            f.type = "Int"
            fields.append(f)
        }
        
        let clz: NSObject.Type = cls as! NSObject.Type
        let tipo = clz.init()
        
        let mirror = Mirror(reflecting: tipo)
        
        if let properties = AnyBidirectionalCollection(mirror.children) {
            for property in properties {
                
                if let label = property.label {
                    let f = Field()
                    f.name = label;
                    f.type = String(describing: type(of: (property.value) as AnyObject))
                    
                    //TODO
                    //f.type = String(f.type).replaceFirstOccurrence(target: "Optional<", withString: "")
                    //f.type = String(f.type).replaceFirstOccurrence(target: ">", withString: "")
                    
                    fields.append(f)
                    
                }
            }
        }
        
        return fields
    }
    
    
}
