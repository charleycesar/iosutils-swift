//
//  DatabaseHelper.swift
//  SugarIOS
//
//  Created by Livetouch on 08/06/16.
//  Copyright © 2016 Livetouch. All rights reserved.
//

import UIKit

import sqlite3

public protocol DatabaseDelegate {
    
    func getDatabaseFile() throws -> String
    
    func getDatabaseVersion() throws -> Int
    
    func getDomainClasses() throws -> [AnyClass]
    
    func onCreate()
    
    func onUpgrade(_ oldVersion: Int, newVersion: Int)
}

open class DatabaseHelper : NSObject, DatabaseDelegate {
    
    //MARK: - Variables
    
    ///Equivalente do Swift para o 'sqlite3 *db'
    open var db: OpaquePointer? = nil;
    
    //MARK: - Inits
    
    override public init() {
        super.init()
        
        start()
    }
    
    //MARK: - Starter
    
    open func start() {
        var dbFile : String!
        do {
            dbFile = try getDatabaseFile()
        } catch {
            log(ExceptionUtils.getDBExceptionMessage(error))
        }
        
        let path = getFilePath(dbFile)
        
        let exists = FileManager.default.fileExists(atPath: path)
        
        log("dbFile \(dbFile)")
        
        db = open(dbFile)
        
        var currentVersion : Int!
        do {
            currentVersion = try getDatabaseVersion()
        } catch {
            log(ExceptionUtils.getDBExceptionMessage(error))
        }
        
        if exists {
            if let oldVersion = Prefs.getInt("db.version") {
                if(oldVersion != currentVersion) {
                    SQLUtils.log("DatabaseHelper.onUpgrade(oldVersion:\(oldVersion), newVersion: \(currentVersion))")
                    
                    onUpgrade(oldVersion, newVersion: currentVersion)
                }
            }
        } else {
            SQLUtils.log("DatabaseHelper.onCreate()")
            
            onCreate()
            Prefs.setInt(currentVersion, forKey: "db.version")
        }
    }

    // Caminho do banco de dados
    fileprivate func getFilePath(_ nome: String) -> String {
        let path = NSHomeDirectory() + "/Documents/" + nome
        log("Database: \(path)")
        return path
    }
    
    //MARK: - Bind
    
    // Faz o bind dos parametros (?,?,?) de um SQL
    open func bindParams(_ stmt:OpaquePointer, params: [AnyObject]) {
        let size = params.count
        
        if (size > 0) {
            for i in 1...size {
                let value : AnyObject = params[i-1]
                
                if let integer = value as? Int {
                    SQLiteUtils.bindInt(stmt, atIndex: i, withInteger: integer)
                
                } else if let double = value as? Double {
                    SQLiteUtils.bindDouble(stmt, atIndex: i, withDouble: double)
                    
                } else if let text = value as? String {
                    SQLiteUtils.bindText(stmt, atIndex: i, withString: text)
                    
                } else {
                    SQLUtils.logError("Value not bound: \(value)")
                }
            }
        }
    }
    
    //MARK: - SQL
    
    // Executa o SQL
    open func execSql(_ sql: String, withParameters params: [AnyObject]? = nil) -> Int {
        var result:CInt = 0
        
        // Statement
        let stmt = query(sql, withParameters: params)
        
        // Step
        result = sqlite3_step(stmt)
        if result != SQLITE_OK && result != SQLITE_DONE {
            sqlite3_finalize(stmt)
            let msg = "Erro ao executar SQL\n\(sql)\nError: \(getLastSqlError())"
            log(msg)
            return -1
        }
        
        // Se for insert recupera o id
        if sql.uppercased().hasPrefix("INSERT") {
            // http://www.sqlite.org/c3ref/last_insert_rowid.html
            let rid = sqlite3_last_insert_rowid(self.db)
            result = CInt(rid)
        } else {
            result = 1
        }
        
        // Fecha o statement
        sqlite3_finalize(stmt)
        
        return Int(result)
    }
    
    open func execSqlExclusive(_ script: String) -> OpaquePointer? {
        var stmt : OpaquePointer? = nil
        
        let sql = script.UTF8String
        
        sqlite3_exec(db, "BEGIN EXCLUSIVE TRANSACTION", nil, nil, nil)
        
        // prepare
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            sqlite3_finalize(stmt)
            log("database prepare error: \(sqlite3_errmsg(db)) - \(script)")
            
            return nil
        }
        
        // execute
        if sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK {
            if sqlite3_exec(db, "COMMIT TRANSACTION", nil, nil, nil) != SQLITE_OK {
                log("Sql Commit Error: \(sqlite3_errmsg(db))")
            }
            
            return stmt!
            
        } else {
            sqlite3_finalize(stmt)
            log("Sql Execute Error: \(sqlite3_errmsg(db))\n[\(script)]")
            
            return nil
        }
    }
    
    // Executa o SQL e retorna o statement
    open func query(_ sql:String, withParameters params: [AnyObject]? = nil) -> OpaquePointer {
        
        var stmt : OpaquePointer? = nil
        
        let cSql = sql.UTF8String
        
        let result = sqlite3_prepare_v2(db, cSql, -1, &stmt, nil)
        
        if (result != SQLITE_OK) {
            sqlite3_finalize(stmt)
            
            let msg = "Erro ao preparar SQL\n\(sql)\nError: \(getLastSqlError())"
            log("SQLite Error: \(msg)")
        }
        
        if let params = params {
            bindParams(stmt!, params:params)
        }
        
        log(sql)
        
        return stmt!
    }
    
    //MARK: - Script
    
    open func execScript(_ filename: String) {
        var script : String?
        
        do {
            let path = try FileUtils.getResourcePathOfFile(filename)
            script = try FileUtils.readBundleFileAtPath(path)
            
        } catch {
            switch error {
                case Exception.genericException:
                    log("Erro ao ler o arquivo '\(filename)'.")
                    
                case Exception.fileNotFoundException:
                    log("Arquivo '\(filename)' não existe.")
                    
                default:
                    break
            }
        }
        
        if let script = script {
            let stmt = execSqlExclusive(script)
            sqlite3_finalize(stmt)
        }
    }
    
    /**
     *  Verifica se a próxima linha da consulta existe.
     *
     *  - returns: Retorna 'true', caso exista a próxima linha da consulta, e 'false' caso contrário.
     */
    open func nextRow(_ stmt: OpaquePointer) -> Bool {
        let result = sqlite3_step(stmt)
        let next = result == SQLITE_ROW
        return next
    }
    
    //MARK: - Helpers
    
    // Abre o banco de dados
    open func open(_ database: String) -> OpaquePointer? {
        
        var db : OpaquePointer? = nil
        
        let path = getFilePath(database)
        let cPath = path.UTF8String
        
        let result = sqlite3_open(cPath, &db)
        
        if(result == SQLITE_CANTOPEN) {
            log("Não foi possível abrir o banco de dados SQLite")
            return nil
        }
        
        return db!
    }
    
    // Fecha o banco de dados
    open func close() {
        sqlite3_close(db)
    }
    
    open func closeStatement(_ stmt:OpaquePointer) {
        // Fecha o statement
        sqlite3_finalize(stmt)
    }
    
    //MARK: - Error
    
    // Retorna o último erro de SQL
    open func getLastSqlError() -> String {
        var err:UnsafePointer<Int8>? = nil
        err = sqlite3_errmsg(db)
        
        if let err = err {
            if let erro = String(validatingUTF8: err) {
                return erro
            }
        }
        
        return ""
    }
    
    //MARK: - Get Information
    
    // Lê uma coluna do tipo Int
    open func getInt(_ stmt:OpaquePointer, index:CInt) -> Int {
        let val = sqlite3_column_int(stmt, index)
        return Int(val)
    }
    
    // Lê uma coluna do tipo Double
    open func getDouble(_ stmt:OpaquePointer, index:CInt) -> Double {
        let val = sqlite3_column_double(stmt, index)
        return Double(val)
    }
    
    // Lê uma coluna do tipo Float
    open func getFloat(_ stmt:OpaquePointer, index:CInt) -> Float {
        let val = sqlite3_column_double(stmt, index)
        return Float(val)
    }
    
    // Lê uma coluna do tipo String
    open func getString(_ stmt:OpaquePointer, index:CInt) -> String {
        let cString  = SQLiteUtils.getText(stmt, atIndex: Int(index))
        
        if let s = String(cString) {
            return s
        }
        return ""
    }
    
    //MARK: - Log
    
    override open func log(_ s:String) {
        SQLUtils.log(s)
    }
    
    //MARK: - Database Delegate
    
    open func getDatabaseFile() throws -> String {
        throw SQLException.notImplemented(message: "getDatabaseFile()")
    }
    
    open func getDatabaseVersion() throws -> Int {
        throw SQLException.notImplemented(message: "getDatabaseVersion()")
    }
    
    open func getDomainClasses() throws -> [AnyClass] {
        throw SQLException.notImplemented(message: "getDomainClasses()")
    }
    
    open func onCreate() {
        SQLUtils.createDatabase()
    }
    
    open func onUpgrade(_ oldVersion: Int, newVersion: Int) {}
}
