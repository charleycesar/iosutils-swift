//
//  Entity.swift
//  SugarIOS
//
//  Created by Livetouch on 08/06/16.
//  Copyright © 2016 Livetouch. All rights reserved.
//

import UIKit

open class Entity : NSObject {
    
    //MARK: - Variables
    
    open var id : Int = -1
    
    //MARK: - Getters
    
    open func getId() -> Int {
        return id
    }
    
    //MARK: - Description
    
    override open var description: String {
        //TODO
        //let json = JSON.toJson(self)
        //return json
        return ""
    }
    
    //MARK: - Database
    
    //MARK: Save
    
    open func save() -> Int {
        do {
            return try SQLUtils.save(self)
        } catch {
            Entity.logDbException(error)
        }
        return -1
    }
    
    //MARK: Delete
    
    open func delete() -> Int {
        do {
            return try SQLUtils.delete(self)
        } catch {
            Entity.logDbException(error)
        }
        return -1
    }
    
    static open func deleteAll() {
        do {
            try SQLUtils.deleteAll(self)
        } catch {
            Entity.logDbException(error)
        }
    }
    
    static open func deleteAllWithQuery(_ query: String, args: [NSObject]) {
        do {
            try SQLUtils.deleteAll(self, whereClause: query, withArguments: args)
        } catch {
            Entity.logDbException(error)
        }
    }
    
    static open func deleteById(_ id:Int) -> Bool {
        do {
            try SQLUtils.deleteById(self, id: id)
            return true
        } catch {
            Entity.logDbException(error)
            return false
        }
    }
    
    //MARK: Find
    
    class open func findById(_ id:Int) -> Self? {
        return SQLUtils.findById(self as NSObject.Type, id: id)
    }
    
    static open func findAll<T:Entity>() -> [T] {
        return SQLUtils.findAll(self)
    }
    
    static open func findAllWithQuery<T: Entity>(_ query:String, andArguments args: [String]) -> [T] {
        return SQLUtils.find(self, query: query, args: args as [NSObject]?)
    }
    
    class open func get(_ id: Int) -> Self? {
        return findById(id)
    }
    
    @available(*, unavailable, message: "Not implemented.")
    static open func first() {
//        List list = findWithQuery(type, "SELECT * FROM " + SqlUtils.toSQLName(type) + " ORDER BY ID ASC LIMIT 1", new String[0]);
//        return list.isEmpty()?null:(Entity)list.get(0);
    }
    
    @available(*, unavailable, message: "Not implemented.")
    static open func last() {
//        List list = findWithQuery(type, "SELECT * FROM " + SqlUtils.toSQLName(type) + " ORDER BY ID DESC LIMIT 1", new String[0]);
//        return list.isEmpty()?null:(Entity)list.get(0);
    }
    
    //MARK: - Database Log
    
    static fileprivate func logDbException(_ exception: Error) {
        LogUtils.log(ExceptionUtils.getDBExceptionMessage(exception))
    }
    
    //MARK: - Parser
    
    /**
     Obtains a Dictionary<String, String> that contains all mappings between atributte names and JSON tags for the class which overrides this method. If the class has no such mappings, it does not need to override this method.
     
     For example, if ["userBirthday" : "user_birthday"] is added, it means that "userBirthday" is the name of the attribute, and "user_birthday" is the equivalent JSON tag.
     
     - Returns: Dictionary<String, String> with name mapping. Returns an empty dictionary by default.
     
     */
    open class func getAttributeMappings() -> [String: String] {
        return [:]
    }
}
