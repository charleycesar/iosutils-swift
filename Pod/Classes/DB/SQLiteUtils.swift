//
//  SQLiteUtils.swift
//  SugarIOS
//
//  Created by Livetouch on 14/06/16.
//  Copyright © 2016 Livetouch. All rights reserved.
//

import Foundation

import sqlite3

open class SQLiteUtils {
    
    //MARK: - Int
    
    static open func bindInt(_ stmt: OpaquePointer, atIndex index: Int, withInteger integer: Int) {
        sqlite3_bind_int(stmt, Int32(index), Int32(integer))
    }
    
    //MARK: - Double
    
    static open func bindDouble(_ stmt: OpaquePointer, atIndex index: Int, withDouble double: Double) {
        sqlite3_bind_double(stmt, Int32(index), double)
    }
    
    //MARK: - Text
    
    static open func bindText(_ stmt: OpaquePointer, atIndex index: Int, withString string: String) {
        sqlite3_bind_text(stmt, Int32(index), string.UTF8String, -1, nil)
    }
    
    static open func getText(_ stmt: OpaquePointer, atIndex index: Int) -> String {
        let result = sqlite3_column_text(stmt, Int32(index))
        //TODO
        return String(describing: result)
        /*let columnText = UnsafePointer<Int8>(result)
        if columnText != nil {
            let length = Int(strlen(columnText))
            
            if let string = NSString(bytes: columnText!, length: length, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }
        
        return ""
 */
    }
    
    static open func setValue(_ value: AnyObject, withName name: String, andObject object: NSObject) {
        object.setValue(value, forKey: name)
    }
}
