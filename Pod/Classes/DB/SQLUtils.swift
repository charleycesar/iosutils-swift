//
//  SQLUtils.swift
//  SugarIOS
//
//  Created by Livetouch on 08/06/16.
//  Copyright © 2016 Livetouch. All rights reserved.
//

import UIKit

open class SQLUtils<T:Entity> : NSObject {
    
    static open func getDatabaseHelper() throws -> DatabaseHelper {
        if let baseAppDelegate = UIApplication.shared.delegate as? BaseAppDelegate {
            return try baseAppDelegate.getConfig().getDatabaseHelper()
        }
        
        throw Exception.notImplemented
    }
    
    static open func saveInTx(list:[T]) {
    
        if let entity : T = list.first {
        
            let fields = ReflectionUtils.getFields(entity.classForCoder)
            
            var sqlStr = ""
            
            for e in list {
                var sql = "insert or replace into \(SQLUtils.toSQLNameClass(e.classForCoder)) ("
                var first = true
                for f in fields {
                    if StringUtils.equalsIgnoreCase(f.name, withString: "id") {
                        continue
                    }
                    
                    if !first {
                        sql.append(",");
                    }
                    sql.append(SQLUtils.toSQLName(f.name))
                    
                    first = false
                }
                sql.append(") VALUES (")
                first = true
                for f in fields {
                    if StringUtils.equalsIgnoreCase(f.name, withString: "id") {
                        continue
                    }
                    if(!first) {
                        sql.append(",");
                    }
                    
                    var value = ReflectionUtils.getFieldValue(e, fieldName: f.name)
                    
                    if (f.type.equalsIgnoreCase(string: "Bool")) {
                        //TODO
                        //value = value.isEqual("true") ? 1 : 0
                    }
                    
                    if (f.type.equalsIgnoreCase(string: "NSDate")) {
                        //TODO
                        //let date = DateUtils.toDate(value as? String, withPattern: "dd/MM/yyyy HH:mm:SS")
                        //TODO
                        //value = DateUtils.toString(date, withPattern: "dd/MM/yyyy HH:mm:SS")
                    }
                    
                    var txt = String(describing: value)
                    txt.insert("'", at: txt.startIndex)
                    txt.insert("'", at: txt.endIndex)
                    sql.append("\(txt)")
                    first = false
                }
                sql.append(");")
                sqlStr.append("\(sql)")
            }
            
            do {
                try getDatabaseHelper().execSqlExclusive(sqlStr)
            } catch let error as NSError {
                LogUtils.log(error.localizedDescription)
            }
        }
    }
    
    static open func getSQLDropTable(_ cls: AnyClass) -> String {
        let table = toSQLNameClass(cls);
        let drop = "drop table if exists \(table);"
        return drop
    }
    
    static open func getSQLCreateDatabase() throws -> [String] {
        
        let classes = try getDatabaseHelper().getDomainClasses()
        
        var sql : [String] = []
        
        for cls in classes {
            let sqlCreate = getSQLCreateTable(cls)
            sql.append(sqlCreate)
        }
        
        return sql
    }
    
    static open func getSQLDropDatabase() throws -> [String] {
        
        let classes = try getDatabaseHelper().getDomainClasses()
        
        var sql : [String] = []
        
        for c in classes {
            sql.append(getSQLDropTable(c))
        }
        
        return sql
    }
    
    static open func getSQLCreateTable(_ cls: AnyClass) -> String {
        
        let fields = ReflectionUtils.getFields(cls)
        
        let table = toSQLNameClass(cls)
        
        var sql = "create table if not exists \(table) (_id integer primary key autoincrement "
        
        var count = 0
        
        for f in fields {
            count+=1
            //Ignora o id, pois cria automaticamente (_id integer primary key autoincrement)
            if("id".equalsIgnoreCase(string: f.name)) {
                continue
            }
            sql.append("\(",")\(toSQLName(f.name)) \(getFieldType(f)) ")
        }
        
        sql.append(");")
        
        return sql
    }
    
    static open func getPatternFields(_ fields: [Field]) -> String {
        var pattern = ""
        var count = 0
        
        for f in fields {
            count+=1
            //Ignora o id, pois cria automaticamente (_id integer primary key autoincrement)
            if("id".equalsIgnoreCase(string: f.name)) {
                continue
            }
            pattern.append("\(count == 1 ? "" : ", ")\(toSQLName(f.name))\(getFieldType(f))\(count == fields.count ? ")" : "")")
        }
        
        return pattern
    }
    
    
    
    static open func toSQLNameClass(_ cls: AnyClass) -> String {
        let name = ReflectionUtils.getClassName(cls)
        return toSQLName(name)
    }
    
    static open func toSQLName(_ name: String) -> String {
        
        //gambi para voltar o nome igual vem do banco, pois no objeto ta id e no banco como _id
        if(StringUtils.equals(name, withString: "id")) {
            return "_id"
        }
        
        var count = 0;
        var nomePattern = ""
        let array = Array(name.characters)
        for character in array {
            let str = String(character)
            if str.lowercased() != str && count > 0 {
                nomePattern.append("_\(str.lowercased())")
            } else {
                nomePattern.append(str.lowercased())
            }
            count+=1
        }
        return nomePattern
    }
    
    static open func getFieldType(_ field:Field) -> String {
        if let type = field.type {
            if("Int".equalsIgnoreCase(string: type)) {
                return "integer"
            } else if("String".equalsIgnoreCase(string: type)) {
                return "text"
            } else if("NSDate".equalsIgnoreCase(string: type)) {
                return "date"
            } else if("Double".equalsIgnoreCase(string: type)) {
                return "double"
            } else if("Long".equalsIgnoreCase(string: type)) {
                return "long"
            } else if("Bool".equalsIgnoreCase(string: type)) {
                return "integer"
            }
        }
        return ""
    }
    
    // Salva um novo registro ou atualiza se já existe id
    static open func save(_ entity: T) throws -> Int {
        
        let id = entity.getId()
        
        let fields = ReflectionUtils.getFields(entity.classForCoder)
        
        let db = findById(entity.classForCoder, id: id)
        let exists = db != nil
        
        if(!exists) {
            // Insert
            var sql = "insert or replace into \(SQLUtils.toSQLNameClass(entity.classForCoder)) ("
            
            // (coluna_a, coluna_b, coluna_c)
            
            var first = true
            
            for f in fields {
                
                if((id == 0 || id == -1) && StringUtils.equalsIgnoreCase(f.name, withString: "id")) {
                    continue
                }
                
                if(!first) {
                    sql.append(",");
                }
                
                sql.append(SQLUtils.toSQLName(f.name))
                
                first = false
            }
            
            // VALUES
            sql.append(") VALUES (")
            
            first = true
            
            for f in fields {
                if((id == 0 || id == -1) && StringUtils.equalsIgnoreCase(f.name, withString: "id")) {
                    continue
                }
                
                if(!first) {
                    sql.append(",");
                }
                
                sql.append("?")
                
                first = false
            }
            
            sql.append(");")
            
            var params : [NSObject] = []
            
            for f in fields {
                if((id == 0 || id == -1) && StringUtils.equalsIgnoreCase(f.name, withString: "id")) {
                    continue
                }
                
                var value = ReflectionUtils.getFieldValue(entity, fieldName: f.name)
                
                /* NÃO EXCLUIR
                ///começo teste
                 
                var valueTESTE = ReflectionUtils.TESTEgetFieldValue(entity, fieldName: f.name)
                 
                if StringUtils.equalsIgnoreCase(f.name, withString: "id") {
                    valueTESTE = id
                }
                 
                ///fim teste
                */
                
                if StringUtils.equals(f.name, withString: "id") {
                    value = id as NSObject
                }
                
                if (f.type.equalsIgnoreCase(string: "Bool")) {
                    //TODO
                    //value = (value.isEqual("true") ? 1 : 0) as NSObject
                }
                
                if (f.type.equalsIgnoreCase(string: "NSDate")) {
                    //TODO
                    //let date = DateUtils.toDate(value as? String, withPattern: "dd/MM/yyyy HH:mm:SS")
                    
                    //value = DateUtils.toString(date, withPattern: "dd/MM/yyyy HH:mm:SS")
                }
                
                params.append(value)
            }
            
            let cid = try execSql(sql, withParameters:params)
            let id = Int(cid)
            
            entity.id = id
            
            return id
            
        } else {
            let id = entity.getId()
            
            // Update
            var sql = "update \(SQLUtils.toSQLNameClass(entity.classForCoder)) set "
            
            var first = true
            
            for f in fields {
                if("id".equalsIgnoreCase(string: f.name)) {
                    continue
                }
                
                if(!first) {
                    sql.append(",");
                }
                
                var value = ReflectionUtils.getFieldValue(entity, fieldName: f.name);
                
                if (f.type.equalsIgnoreCase(string: "Bool")) {
                    //TODO
                    //value = value.isEqual("true") ? 1 : 0 as NSObject
                    
                    sql.append("\(SQLUtils.toSQLName(f.name)) = \(value)")
                    
                } else if (f.type.equalsIgnoreCase(string: "NSDate")) {
                    //TODO
                    //let date = DateUtils.toDate(value as? String, withPattern: "dd/MM/yyyy HH:mm:SS")
                    //TODO
                    //value = DateUtils.toString(date, withPattern: "dd/MM/yyyy HH:mm:SS")
                    
                    sql.append("\(SQLUtils.toSQLName(f.name)) = '\(value)'")
                    
                } else {
                    sql.append("\(SQLUtils.toSQLName(f.name)) = '\(value)'")
                }
                
                first = false
            }
            
            sql.append(" where _id = \(id)" )
            
            try execSql(sql)
            
            return id
        }
    }
    
    static open func find(_ cls: AnyClass) -> [T] {
        return find(cls, query:"", args: [], orderBy: nil)
    }
    
    static fileprivate func isBasicClassString(_ string: String) -> Bool {
        if string.equalsIgnoreCase(string: "String") || string.equalsIgnoreCase(string: "NSNumber") || string.equalsIgnoreCase(string: "Int") || string.equalsIgnoreCase(string: "Float") || string.equalsIgnoreCase(string: "Double") || string.equalsIgnoreCase(string: "UInt") || string.equalsIgnoreCase(string: "Bool") || string.equalsIgnoreCase(string: "NSDictionary") || string.equalsIgnoreCase(string: "NSString") {
            return true
        }
        
        return false
    }
    
    static open func query(_ cls:AnyClass, sql:String, params: [AnyObject]? = nil) -> [T] {
        var list:[T] = []
        
        var db : DatabaseHelper!
        do {
            db = try getDatabaseHelper()
        } catch {
            log(ExceptionUtils.getDBExceptionMessage(error))
            return []
        }
        
        let stmt = db.query(sql, withParameters: params)
        
        let fields = ReflectionUtils.getFields(cls)
        
        while (db.nextRow(stmt)) {
            
            let clz: NSObject.Type = cls as! NSObject.Type
            let entity = clz.init() as! T
            
            var idx = 0;
            for f in fields {
                var value : AnyObject?
                
                if StringUtils.equals(f.name, withString: "id") {
                    entity.id = db.getInt(stmt, index: Int32(idx))
                }
                
                if f.type.equalsIgnoreCase(string: "Int") {
                    value = db.getInt(stmt, index: Int32(idx))as AnyObject?
                    
                } else if (f.type.equalsIgnoreCase(string: "Float")) {
                    value = db.getFloat(stmt, index: Int32(idx))as AnyObject?
                    
                } else if (f.type.equalsIgnoreCase(string: "Double")) {
                    value = db.getDouble(stmt, index: Int32(idx))as AnyObject?
                    
                } else if (f.type.containsStringIgnoreCase(find: "String")) {
                    value = db.getString(stmt, index: Int32(idx))as AnyObject?
                    
                } else if (f.type.equalsIgnoreCase(string: "NSDate")) {
                    value = db.getString(stmt, index: Int32(idx))as AnyObject?
                } else if (f.type.equalsIgnoreCase(string: "Bool")) {
                    //TODO
                    //value = db.getInt(stmt, index: Int32(idx)) == 1 ? true : false
                }
                
                guard let newValue = value else {
                    idx += 1
                    continue
                }
                
                ReflectionUtils.setFieldValue(entity, fieldName: f.name, value: newValue)
                
                idx += 1
            }
            
            list.append(entity)
        }
        
        db.closeStatement(stmt)
        
        return list
    }
    
    static open func find(_ cls: AnyClass, query: String?, args: [NSObject]?, orderBy: String? = nil) -> [T] {
        
        var list : [T] = []
        
        var sql = "select * from \(SQLUtils.toSQLNameClass(cls))"
        
        if let q = query {
            if (StringUtils.isNotEmpty(q)) {
                sql += " where \(q)"
            }
        }
        
        if let o = orderBy {
            if (StringUtils.isNotEmpty(o)) {
                sql += " order by LOWER(\(o))"
            }
        }
        
        var db : DatabaseHelper!
        do {
            db = try getDatabaseHelper()
        } catch {
            log(ExceptionUtils.getDBExceptionMessage(error))
            return []
        }
        
        let stmt = db.query(sql, withParameters: args)
        
        let fields = ReflectionUtils.getFields(cls)
        
        while (db.nextRow(stmt)) {
            
            let clz: NSObject.Type = cls as! NSObject.Type
            let entity = clz.init() as! T
            
            var idx = 0;
            for f in fields {
                var value : AnyObject?
                
                if StringUtils.equals(f.name, withString: "id") {
                    entity.id = db.getInt(stmt, index: Int32(idx))
                }
                
                if f.type.equalsIgnoreCase(string: "Int") {
                    value = db.getInt(stmt, index: Int32(idx)) as AnyObject?
                    
                } else if (f.type.equalsIgnoreCase(string: "Float")) {
                    value = db.getFloat(stmt, index: Int32(idx)) as AnyObject?
                    
                } else if (f.type.equalsIgnoreCase(string: "Double")) {
                    value = db.getDouble(stmt, index: Int32(idx)) as AnyObject?
                    
                } else if (f.type.containsStringIgnoreCase(find: "String")) {
                    value = db.getString(stmt, index: Int32(idx)) as AnyObject?
                    
                } else if (f.type.equalsIgnoreCase(string: "NSDate")) {
                    value = db.getString(stmt, index: Int32(idx)) as AnyObject?
                } else if (f.type.equalsIgnoreCase(string: "Bool")) {
                    //TODO
                    //value = db.getInt(stmt, index: Int32(idx)) == 1 ? true : false
                }
                
                guard let newValue = value else {
                    idx += 1
                    continue
                }
                
                ReflectionUtils.setFieldValue(entity, fieldName: f.name, value: newValue)
                
                idx += 1
            }
            
            list.append(entity)
        }
        
        db.closeStatement(stmt)
        
        return list
    }

    static open func findById(_ cls: AnyClass, id: Int) -> T? {
        let list = find(cls, query:"_id=?",args: [id as NSObject])
        if(list.count > 0) {
            return list[0]
        }
        return nil
    }
    
    static open func findAllById(_ cls: AnyClass, id: Int) -> [T]? {
        let list = find(cls, query:"_id=?",args: [id as NSObject])
        if(list.count > 0) {
            return list
        }
        return nil
    }
    
    static open func findAll(_ cls: AnyClass) -> [T] {
        return find(cls)
    }
    
    static open func findAllOrderBy(_ cls:AnyClass, orderBy: String) -> [T] {
        return find(cls, query: nil, args: nil, orderBy: "nome")
    }
    
    // Deleta uma entity pelo id
    static open func delete(_ entity: T) throws -> Int {

        let id = entity.getId()
        
        if(id == 0 || id == -1) {
            log("id inválido: [\(id)]")
        } else {
            //Delete
            let sql = "delete from \(SQLUtils.toSQLNameClass(entity.classForCoder)) where _id = \(entity.getId());"
            let count = try execSql(sql)
            
            log("delete ok")
            
            return Int(count)
        }
        
        return -1
    }
    
    static open func deleteAll(_ cls: AnyClass, whereClause clause: String? = nil, withArguments args: [NSObject]? = nil) throws -> Int {
        
        let table = SQLUtils.toSQLNameClass(cls)
        var sql = "delete from \(table)"
        
        if let query = clause {
            sql += " where \(query)"
        }
        
        return try execSql(sql, withParameters: args)
    }
    
    static open func deleteById(_ cls: AnyClass, id: Int) throws -> Bool {
        try deleteAll(cls, whereClause: "_id = ?", withArguments: [id as NSObject])
        return true
    }
    
    static open func printTable(_ cls: AnyClass) -> Bool {
        LogUtils.log("\n### start print table \(cls) ###")
        let list: [T] = findAll(cls)
        for entity in list {
            // TODO json
            let json = String(describing: entity)
            LogUtils.log("id [\(entity.getId())] : \(json)")
        }
        LogUtils.log("### end print table \(cls) ###")
        return true
    }
    
    static open func createDatabase() {
        do {
            let sqls = try getSQLCreateDatabase()
            for sql in sqls {
                try execSql(sql)
            }
        } catch {
            log(ExceptionUtils.getDBExceptionMessage(error))
        }
    }
    
    static open func dropDatabase() {
        do {
            let sqls = try getSQLDropDatabase()
            for sql in sqls {
                try execSql(sql)
            }
        } catch {
            log(ExceptionUtils.getDBExceptionMessage(error))
        }
    }

    
    
    static open func execSql(_ sql: String, withParameters params: [AnyObject]? = nil) throws -> Int {
        do {
            return try getDatabaseHelper().execSql(sql, withParameters: params)
        } catch {
            throw error
        }
    }
    
    /**
     * Retorna a lista de ids no formato id1,id2,id3
     * @param ids
     * @return
     */
    static open func toSQLIn(_ ids: [Int]) -> String {
        var sb : String = ""
        var first = true
        for id in ids {
            if(!first) {
                sb.append(",")
            }
            sb.append(String(id))
            first = false
        }
        return sb
    }
    
    static open func logError(_ s: String) {
        LogUtils.log("(SQL error): \(s)")
    }
    
    static open func log(_ s: String) {
        LogUtils.log("(SQL) - \(s)")
    }
}
