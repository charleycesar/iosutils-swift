//
//  ClassUtils.swift
//  Pods
//
//  Created by Guilherme Politta on 6/07/16.
//
//

import UIKit

open class ClassUtils: NSObject {
    
    //MARK: - Basica Class
    
    static open func isBasicClass(_ any : Any) -> Bool {
        if any is String || any is NSNumber || any is Int || any is Float || any is Double || any is UInt || any is Bool || any is NSDictionary || any is NSString {
            return true
        }
        
        return false
    }
    
    static open func isBasicClassString(string: String) -> Bool {
        //if string.equalsIgnoreCase(string: "String") || string.equalsIgnoreCase(string: "NSNumber") || string.equalsIgnoreCase(string: "Int") || string.equalsIgnoreCase(string: "Float") || string.equalsIgnoreCase(string: "Double") || string.equalsIgnoreCase(string: "UInt") || string.equalsIgnoreCase(string: "Bool") || string.equalsIgnoreCase(string: "NSDictionary") || string.equalsIgnoreCase(string: "NSString") {
           // return true
        //}
        
        return false
    }

    //MARK: - Class From String
    
    static open func swiftClassFromString(_ className: String) -> NSObject? {
        var result: NSObject? = nil
        if className == "NSObject" {
            return NSObject()
        }
        if let anyobjectype : AnyObject.Type = swiftClassTypeFromString(className) {
            if let nsobjectype : NSObject.Type = anyobjectype as? NSObject.Type {
                let nsobject: NSObject = nsobjectype.init()
                result = nsobject
            }
        }
        return result
    }
    
    static open func swiftClassTypeFromString(_ className: String, namespace: String? = nil) -> AnyClass? {
        if className.hasPrefix("_Tt") {
            return NSClassFromString(className)
        }
        var classStringName = className
        if className.range(of: ".", options: NSString.CompareOptions.caseInsensitive) == nil {
            if let namespace = namespace {
                classStringName = "\(namespace).\(className)"
                if let cls = NSClassFromString(classStringName) {
                    return cls
                } else {
                    let appName = getCleanAppName()
                    classStringName = "\(appName).\(className)"
                }
            }
        }
        return NSClassFromString(classStringName)
    }
    
    static open func getCleanAppName(_ forObject: NSObject? = nil)-> String {
        var bundle = Bundle.main
        if forObject != nil {
            bundle = Bundle(for: type(of: forObject!))
        }
        
        var appName = bundle.infoDictionary?["CFBundleName"] as? String ?? ""
        if appName == "" {
            appName = (bundle.bundleIdentifier!).characters.split(whereSeparator: {$0 == "."}).map({ String($0) }).last ?? ""
        }
        let cleanAppName = appName
            .replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.caseInsensitive, range: nil)
            .replacingOccurrences(of: "-", with: "_", options: NSString.CompareOptions.caseInsensitive, range: nil)
        return cleanAppName
    }
    
    //MARK: - String from Class
    
    static open func classNameAsString(_ obj: Any) -> String {
        if #available(iOS 9, *) {
            return String(reflecting: type(of: (obj) as AnyObject))
        } else {
            return String(describing: type(of: (obj) as AnyObject)).components(separatedBy: "__").last!
        }
    }
    
}
