//
//  Prefs.swift
//  Pods
//
//  Created by Ricardo Lecheta on 6/30/14.
//  Copyright (c) 2014 Ricardo Lecheta. All rights reserved.
//

import Foundation

open class Prefs {
    
    //MARK: - Synchronize
    
    static open func synchornize() {
        let prefs = UserDefaults.standard
        prefs.synchronize()
    }
    
    //MARK: - String
    
    static open func setString(_ value: String, forKey key: String) {
        let prefs = UserDefaults.standard
        prefs.setValue(value, forKey: key)
        prefs.synchronize()
    }
    
    static open func getString(_ key: String) -> String {
        let prefs = UserDefaults.standard
        if let s = prefs.string(forKey: key) {
            return s
        }
        return ""
    }
    
    //MARK: - Int
    
    static open func setInt(_ value: Int, forKey key: String) {
        let prefs = UserDefaults.standard
        prefs.set(value, forKey: key)
        prefs.synchronize()
    }

    static open func getInt(_ key: String) -> Int! {
        let prefs = UserDefaults.standard
        let i = prefs.integer(forKey: key)
        return i
    }
    
    //MARK: - Float
    
    static open func setFloat(_ value: Float, forKey key: String) {
        let prefs = UserDefaults.standard
        prefs.set(value, forKey: key)
        prefs.synchronize()
    }
    
    static open func getFloat(_ key: String) -> Float {
        let prefs = UserDefaults.standard
        let f = prefs.float(forKey: key)
        return f
    }
    
    //MARK: - Double
    
    static open func setDouble(_ value: Double, forKey key: String) {
        let prefs = UserDefaults.standard
        prefs.set(value, forKey: key)
        prefs.synchronize()
    }
    
    static open func getDouble(_ key: String) -> Double {
        let prefs = UserDefaults.standard
        let d = prefs.double(forKey: key)
        return d
    }
    
    //MARK: - Boolean
    
    static open func setBoolean(_ value: Bool, forKey key: String) {
        let prefs = UserDefaults.standard
        prefs.set(value, forKey: key)
        prefs.synchronize()
    }
    
    static open func getBoolean(_ key: String) -> Bool {
        let prefs = UserDefaults.standard
        let b = prefs.bool(forKey: key)
        return b
    }
    
    //MARK: - Object
    
    static open func setObject(_ value: AnyObject, forKey key: String) {
        let prefs = UserDefaults.standard
        let objectData = NSKeyedArchiver.archivedData(withRootObject: value)
        prefs.set(objectData, forKey: key)
        prefs.synchronize()
    }
    
    static open func getObject(_ key: String) -> AnyObject? {
        let prefs = UserDefaults.standard
        if let data = prefs.object(forKey: key) as? Data {
            let o = NSKeyedUnarchiver.unarchiveObject(with: data)
            return o as AnyObject?
        }
        return nil
    }
    
    //MARK: - Json
    
    static open func setJson(_ object: AnyObject, forKey key: String) throws -> String {
        var json: String!
        if (object is NSArray) {
            json = try (object as! NSArray).toJsonString()
        } else if (object is NSDictionary) {
            json = try (object as! NSDictionary).toJsonString()
        } else if (object is NSObject) {
            json = try (object as! NSObject).toJsonString()
        } else {
            throw NSError(domain: "PrefsDomain", code: 1, userInfo: [NSLocalizedDescriptionKey : "Não foi possível transformar o objeto em json"])
        }
        
        Prefs.setString(json, forKey: key)
        return json
    }
    
    /*//TODO
    static open func getJson(_ cls: AnyClass, forKey key: String) throws -> AnyObject {
        let json = Prefs.getString(key)
        let o = try JSON.fromJson(string: json, cls: cls)
        return o
    }*/
    
    //MARK: - Clear
    
    static open func clearAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            let prefs = UserDefaults.standard
            prefs.removePersistentDomain(forName: appDomain)
        }
    }
}
