//
//  JSON.swift
//  DesafioLTS
//
//  Created by Guilherme Politta on 08/06/16.
//  Copyright © 2016 Livetouch. All rights reserved.
//

import Foundation

import DCKeyValueObjectMapping
import sqlite3

open class JSON {
//TODO
    /*static open func bindText(_ stmt: OpaquePointer, atIndex index: Int, withString string: String) {
        sqlite3_bind_text(stmt, Int32(index), string.UTF8String, -1, nil)
    }
    
    static open func getText(_ stmt: OpaquePointer, atIndex index: Int) -> String {
        if let s = sqlite3_column_text(stmt, Int32(index)) {
            //TODO
            if let string = NSString(bytes: s, length: s.hashValue, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }
        return ""
    }
    
    static open func setValue(_ value: String, withName name: String, andObject object: NSObject) {
        object.setValue(value, forKey: name)
    }
    
    //MARK: - Configurations
    
    static fileprivate func getParseConfigs(_ cls: AnyClass) -> [ParseConfig] {
        return getParseConfigs(cls, clsArray: [])
    }
    
    static fileprivate func getParseConfigs(_ cls: AnyClass, clsArray: [String]) -> [ParseConfig] {
        
        var parsedClassesArray = clsArray
        
        let clz: NSObject.Type = cls as! NSObject.Type
        let tipo = clz.init()
        
        let mirror = Mirror(reflecting: tipo)
        let mirrorType = mirror.subjectType as! NSObject.Type
        
        var nameSpace: String?
        if #available(iOS 9, *) {
            let mirrorTypeString = String(reflecting: mirrorType)
            nameSpace = mirrorTypeString.split(separator: ".").first
        }
        
        var parseConfigs : [ParseConfig] = []
        
        if (cls is Entity.Type) {
            let entity = cls as! Entity.Type
            let mappings = entity.getAttributeMappings()
            
            let keys = mappings.keys
            for key in keys {
                let mapping = mappings[key]!
                parseConfigs.append(ParseConfig(container: mirrorType.classForCoder(), attribute: key, remoteAttribute: mapping))
            }
        }
        
        if let children = AnyBidirectionalCollection(mirror.children) {
            for item in children {
                
                if ClassUtils.isBasicClass(item.value)  {
                    continue
                }
                
                if let _ = item.value as? NSArray {
                    
                    let itemMirror = Mirror(reflecting: item.value)
                    
                    let itemMirroType = itemMirror.subjectType
                    
                    var arrayClassString = "\(itemMirroType)"
                    arrayClassString = arrayClassString.replaceFirstOccurrence(target: "Array<", withString: "")
                    arrayClassString = arrayClassString.replaceFirstOccurrence(target: ">", withString: "")
                    
                    guard let arrayElementClass : AnyClass = ClassUtils.swiftClassTypeFromString(arrayClassString, namespace: nameSpace) else {
                        continue
                    }
                    
                    if let itemLabel = item.label {
                        let parseConfig = ParseConfig(container: mirrorType.classForCoder(), contained: arrayElementClass, attribute: itemLabel)
                        
                        parseConfigs.append(parseConfig)
                        
                        if (parsedClassesArray.contains(arrayClassString)) {
                            continue
                        }
                        
                        parsedClassesArray.append(arrayClassString)
                        
                        parseConfigs.append(contentsOf: getParseConfigs(arrayElementClass, clsArray: parsedClassesArray))
                    }
                } else {
                    let itemMirror = Mirror(reflecting: item.value)
                    
                    let itemMirroType = itemMirror.subjectType
                    
                    var classString = "\(itemMirroType)"
                    classString = classString.replaceFirstOccurrence(target: "Optional<", withString: "")
                    classString = classString.replaceFirstOccurrence(target: ">", withString: "")
                    
                    
                    if (ClassUtils.isBasicClassString(classString) || parsedClassesArray.contains(classString)) {
                        continue
                    }
                    
                    parsedClassesArray.append(classString)
                    
                    if let elementClass : AnyClass = ClassUtils.swiftClassTypeFromString(classString, namespace: nameSpace) {
                        parseConfigs.append(contentsOf: getParseConfigs(elementClass, clsArray: parsedClassesArray))
                    }
                }
            }
        }
        
        return parseConfigs
    }
    
    //MARK: - Parse Object
    
    static open func fromJson(string: String?, cls: AnyClass) throws -> AnyObject {
        
        guard let string = string , StringUtils.isNotEmpty(string) else {
            throw Exception.jsonException
        }
        
        guard let data = string.data(using: String.Encoding.utf8) else {
            throw Exception.jsonException
        }
        
        return try fromJson(data: data, cls: cls)
    }
    
    static open func fromJson(data: Data, cls: AnyClass) throws -> AnyObject {
        
        if (data.count == 0) {
            throw Exception.genericException(message: "Retorno vazio do servidor.")
        }
        
        return try fromJson(data: data, cls: cls, attributes: getParseConfigs(cls))
    }
    
    static open func fromJson(data: Data, cls: AnyClass, attributes :[ParseConfig]) throws -> AnyObject {
        
        var dict : [AnyHashable: Any]!
        do {
            dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyHashable: Any]
        } catch {
            throw Exception.jsonException
        }
        
        let config = DCParserConfiguration()
        
        for attribute in attributes {
            if attribute.isAttributeMapping {
                config.add(attribute.getObjectMapping())
            } else {
                config.addArrayMapper(attribute.getArrayMapping())
            }
        }
        
        let parser = DCKeyValueObjectMapping.mapper(for: cls, andConfiguration: config)
        
        let obj = parser?.parseDictionary(dict)
        
        if let obj = obj {
            return obj as AnyObject
        }
        
        throw NSError(domain: "ParseJsonDomain", code: 1, userInfo: [NSLocalizedDescriptionKey : "Erro ao fazer parse na resposta."])
    }
    
    //MARK: - Parse List
    
    static open func fromJsonList(string: String?, cls: AnyClass) throws -> [AnyObject] {
        
        guard let string = string , StringUtils.isNotEmpty(string) else {
            throw Exception.jsonException
        }
        
        guard let data = string.data(using: String.Encoding.utf8) else {
            throw Exception.jsonException
        }
        
        return try fromJsonList(data: data, cls: cls)
    }
    
    static open func fromJsonList(data: Data, cls : AnyClass) throws -> [AnyObject] {
        
        if (data.count == 0) {
            throw Exception.genericException(message: "Retorno vazio do servidor.")
        }
        
        return try fromJsonList(data: data, cls: cls, attributes: getParseConfigs(cls))
    }
    
    static open func fromJsonList(data: Data, cls: AnyClass, attributes: [ParseConfig]) throws -> [AnyObject] {
        
        var listRetorno : [AnyObject] = []
        
        var array : [AnyObject]!
        do {
            array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
        } catch {
            throw Exception.jsonException
        }
        
        let config = DCParserConfiguration()
        
        for attribute in attributes {
            if attribute.isAttributeMapping {
                config.add(attribute.getObjectMapping())
            } else {
                config.addArrayMapper(attribute.getArrayMapping())
            }
        }
        
        let parser = DCKeyValueObjectMapping.mapper(for: cls, andConfiguration: config)
        
        for objArray in array {
            let dict = objArray as! [AnyHashable: Any]
            if let parser = parser {
                let obj = parser.parseDictionary(dict)
                
                if let obj = obj {
                    listRetorno.append(obj as AnyObject)
                }
            }
        }
        
        return listRetorno
    }
    
    //MARK: - JSONSerializer
    
    /**
     Errors that indicates failures of JSONSerialization
     - JsonIsNotDictionary:	-
     - JsonIsNotArray:		-
     - JsonIsNotValid:		-
     */
    public enum JSONSerializerError: Error {
        case jsonIsNotDictionary
        case jsonIsNotArray
        case jsonIsNotValid
    }
    
    //http://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    /**
     Tries to convert a JSON string to a NSDictionary. NSDictionary can be easier to work with, and supports string bracket referencing. E.g. personDictionary["name"].
     - parameter jsonString:	JSON string to be converted to a NSDictionary.
     - throws: Throws error of type JSONSerializerError. Either JsonIsNotValid or JsonIsNotDictionary. JsonIsNotDictionary will typically be thrown if you try to parse an array of JSON objects.
     - returns: A NSDictionary representation of the JSON string.
     */
    open static func toDictionary(_ jsonString: String) throws -> NSDictionary {
        
        if let dictionary = try jsonToAnyObject(jsonString) as? NSDictionary {
            return dictionary
        } else {
            throw JSONSerializerError.jsonIsNotDictionary
        }
    }
    
    /**
     Tries to convert a JSON string to a NSArray. NSArrays can be iterated and each item in the array can be converted to a NSDictionary.
     - parameter jsonString:	The JSON string to be converted to an NSArray
     - throws: Throws error of type JSONSerializerError. Either JsonIsNotValid or JsonIsNotArray. JsonIsNotArray will typically be thrown if you try to parse a single JSON object.
     - returns: NSArray representation of the JSON objects.
     */
    open static func toArray(_ jsonString: String) throws -> NSArray {
        if let array = try jsonToAnyObject(jsonString) as? NSArray {
            return array
        } else {
            throw JSONSerializerError.jsonIsNotArray
        }
    }
    
    /**
     Tries to convert a JSON string to AnyObject. AnyObject can then be casted to either NSDictionary or NSArray.
     - parameter jsonString:	JSON string to be converted to AnyObject
     - throws: Throws error of type JSONSerializerError.
     - returns: Returns the JSON string as AnyObject
     */
    fileprivate static func jsonToAnyObject(_ jsonString: String) throws -> AnyObject? {
        var any: AnyObject?
        
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                any = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! AnyObject?
            }
            catch let error as NSError {
                let sError = String(describing: error)
                NSLog(sError)
                throw JSONSerializerError.jsonIsNotValid
            }
        }
        return any
    }
    
    /**
     Generates the JSON representation given any custom object of any custom class. Inherited properties will also be represented.
     - parameter object:	The instantiation of any custom class to be represented as JSON.
     - returns: A string JSON representation of the object.
     */
    open static func toJson(_ object: Any, prettify: Bool = false) -> String {
        var json = "{"
        let mirror = Mirror(reflecting: object)
        
        var children = [(label: String?, value: Any)]()
        let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children)!
        children += mirrorChildrenCollection
        
        var currentMirror = mirror
        while let superclassChildren = currentMirror.superclassMirror?.children {
            let randomCollection = AnyRandomAccessCollection(superclassChildren)!
            children += randomCollection
            currentMirror = currentMirror.superclassMirror!
        }
        
        var filteredChildren = [(label: String?, value: Any)]()
        for (optionalPropertyName, value) in children {
            if !optionalPropertyName!.contains("notMapped_") {
                //TODO
                //filteredChildren += [(optionalPropertyName, value)]
            }
        }
        
        var skip = false
        let size = filteredChildren.count
        var index = 0
        
        for (optionalPropertyName, value) in filteredChildren {
            skip = false
            
            let propertyName = optionalPropertyName!
            let property = Mirror(reflecting: value)
            
            var handledValue = String()
            
            if propertyName == "Some" && property.displayStyle == Mirror.DisplayStyle.struct {
                handledValue = toJson(value)
                skip = true
            }
            else if (value is Int || value is Double || value is Float || value is Bool) &&
                property.displayStyle != Mirror.DisplayStyle.optional {
                handledValue = String(describing: value ?? "null")
            }
            else if let array = value as? [Int?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Double?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Float?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Bool?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [String?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? "\"\(value!)\"" : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [String] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += "\"\(value)\""
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? NSArray {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    if !(value is Int) && !(value is Double) && !(value is Float) && !(value is Bool) && !(value is String) {
                        handledValue += toJson(value)
                    }
                    else {
                        handledValue += "\(value)"
                    }
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if property.displayStyle == Mirror.DisplayStyle.class ||
                property.displayStyle == Mirror.DisplayStyle.struct ||
                String(describing: type(of: (value) as AnyObject)).contains("#") {
                handledValue = toJson(value)
            }
            else if property.displayStyle == Mirror.DisplayStyle.optional {
                let str = String(describing: value)
                if str != "nil" {
                    handledValue = String(str).substring(with: str.characters.index(str.startIndex, offsetBy: 9)..<str.characters.index(str.endIndex, offsetBy: -1))
                } else {
                    handledValue = "null"
                }
            }
            else {
                handledValue = String(describing: value) != "nil" ? "\"\(value)\"" : "null"
            }
            
            if !skip {
                json += "\"\(propertyName)\": \(handledValue)" + (index < size-1 ? ", " : "")
            } else {
                json = "\(handledValue)" + (index < size-1 ? ", " : "")
            }
            
            index += 1
        }
        
        if !skip {
            json += "}"
        }
        
        if prettify {
            let jsonData = json.data(using: String.Encoding.utf8)!
            let jsonObject:AnyObject = try! JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject
            let prettyJsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            json = NSString(data: prettyJsonData, encoding: String.Encoding.utf8.rawValue)! as String
        }
        
        return json
    }
    
    //MARK: - Dictionary
    
    open class func toJsonDictionary(_ dict: Dictionary<String, AnyObject>) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as? String
            
            if let json = string {
                
                return json;
            }
            
            return ""
        } catch let error as NSError {
            print(error)
        }
        
        return ""
    }
    
    open class func toJsonDictionary(_ dict:NSDictionary) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as? String
            
            if let json = string {
                
                return json;
            }
            
            return ""
        } catch let error as NSError {
            print(error)
        }
        
        return ""
    }
*/
}
