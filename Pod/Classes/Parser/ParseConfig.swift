//
//  ParseConfig.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 08/04/2016.
//
//

import UIKit

import DCKeyValueObjectMapping

open class ParseConfig: NSObject {
    
    //MARK: - Attributes
    
    var container   : AnyClass!
    
    var contained   : AnyClass!
    var attribute   : String!
    
    var remoteAttribute : String!
    
    var isAttributeMapping : Bool = false
    
    //MARK: - Inits
    
    init(container: AnyClass, contained: AnyClass, attribute: String) {
        self.container = container
        self.contained = contained
        self.attribute = attribute
        self.isAttributeMapping = false
    }
    
    init(container: AnyClass, attribute: String, remoteAttribute: String) {
        self.container = container
        self.attribute = attribute
        self.remoteAttribute = remoteAttribute
        self.isAttributeMapping = true
    }
    
    //MARK: - Methods
    
    open func getArrayMapping() -> DCArrayMapping {
        return DCArrayMapping.mapper(forClassElements: self.contained, forAttribute: self.attribute, on: self.container)
    }
    
    open func getObjectMapping() -> DCObjectMapping {
        return DCObjectMapping.mapKeyPath(self.remoteAttribute, toAttribute: self.attribute, on: self.container)
    }
}
