//
//  SyncService.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 12/04/2016.
//
//

import UIKit

open class SyncService {
    
    //MARK: - Helpers
    
    static open func isNetworkAvailable() -> Bool {
        return NetworkUtils.isAvailable()
    }
    
    static open func getParams(_ params: [String: AnyObject]?) -> [String: AnyObject] {
        guard let params = params else {
            return [:]
        }
        
        return params
    }
    
    //MARK: - Synchronization
    
    static open func sync<V: SyncHelper>(_ helper: V, params: [String: AnyObject], refresh: Bool) throws -> Bool where V.T: Entity {
        LogUtils.log(">> entrou no sync")
        
        let networkOk = isNetworkAvailable()
        LogUtils.log(">> networkOk: \(networkOk)")
        
        if !networkOk {
            return false
        }
        
        let cls : AnyClass = helper.getDomainClass()
        
        /**
         * DELETE
         */
        LogUtils.log(">> tentou deletar")
        
        var list : [V.T] = []
        list = SQLUtils.find(cls, query: "to_delete = ?", args: ["1" as NSObject])
        
        var ids = try helper.postDeleteWs(list, params: params)
        for id in ids {
            let ok = try SQLUtils.deleteById(cls, id: id)
            LogUtils.log("SyncService.delete cls [ \(type(of: cls))], id [\(id)], ok [\(ok)]")
        }
        
        /**
         * INSERT
         */
        list = SQLUtils.find(cls, query: "id_server = ? ", args: ["-1" as NSObject])
        ids = try helper.postSaveWs(list, params: params)
        
        for id in ids {
            LogUtils.log("SyncService.save cls [\(type(of: cls))], id [\(id)]")
        }
        
        /**
         * UPDATE
         */
        list = SQLUtils.find(cls, query: "id_server != -1 and to_update = ?", args: ["1" as NSObject])
        ids = try helper.postSaveWs(list, params: params)
        
        let sqlParamsIn = SQLUtils.toSQLIn(ids)
        // Atualiza registros que foram atualizados
        try SQLUtils.execSql("update \(SQLUtils.toSQLNameClass(cls)) set to_update = 0 where id in (\(sqlParamsIn))")
        
        LogUtils.log("<< SyncService.MERGE!")
        
        if refresh {
            try listOnlineFirst(helper, params: params)
        }
        
        LogUtils.log("<< SyncService.sync")
        
        return true
    }
    
    //MARK: - Online
    
    static open func listOnlineFirst<V: SyncHelper>(_ helper: V, params: [String: AnyObject]) throws -> [V.T] where V.T: Entity {
        
        let networkOk = isNetworkAvailable()
        LogUtils.log(">> networkOk: \(networkOk)")
        
        if (networkOk) {
            // Get from WS
            let ws = try helper.getListFromWS(getParams(params))
            LogUtils.log("ws: \(ws.count) objects")
            
            let listOk = !ws.isEmpty && ws.count > 0
            
            if (listOk) {
                // SyncUpdateDbMode
                LogUtils.log("delete All")
                helper.deleteAllBeforeRefresh(getParams(params))
                
                // Save BD
                LogUtils.log("save: \(ws.count) objects")
                helper.save(ws, params: getParams(params))
                
                LogUtils.log("<< SyncService.list ws: \(ws.count) objects")
                return ws
            }
        }
        
        // BD
        let bd = try helper.getListFromDB(getParams(params))
        LogUtils.log("<< SyncService.list bd: \(bd.count) objects")
        return bd
    }
    
    //MARK: - Offline
    
    static open func listOfflineFirst<V: SyncHelper>(_ helper: V, params: [String: AnyObject], forceUpdate: Bool) throws -> [V.T] where V.T: Entity {
        
        let networkOk = isNetworkAvailable()
        
        // BD
        var bd : [V.T] = []
        bd = try helper.getListFromDB(params)
        var listOk = !bd.isEmpty && bd.count > 0
        
        LogUtils.log("<< SyncService.list bd: \((bd.count)) objects")
        
        if (listOk && !forceUpdate) {
            return bd
        }
        
        LogUtils.log(">> networkOk: \(networkOk)")
        
        if (networkOk) {
            // Get from WS
            var ws : [V.T] = []
            ws = try helper.getListFromWS(getParams(getParams(params)))
            LogUtils.log("ws: \(ws.count) objects")
            
            listOk = !ws.isEmpty && ws.count > 0
            if (listOk) {
                // SyncUpdateDbMode
                LogUtils.log("delete All")
                helper.deleteAllBeforeRefresh(getParams(params))
                
                // Save BD
                LogUtils.log("save: \(ws.count) objects")
                helper.save(ws, params: getParams(getParams(params)))
                
                LogUtils.log("<< SyncService.list ws: \(ws.count) objects")
                return ws
            }
        } else {
            LogUtils.log("offline, no network")
        }
        
        // Se network nao ok, retorna do BD
        LogUtils.log("<< SyncService.list bd: \(bd.count) objects")
        return bd
    }
    
    //MARK: - Version
    
    open static func listVersion<V: SyncHelper>(_ helper: V, params: [String: AnyObject], forceUpdate: Bool) throws -> [V.T] where V.T: Entity {
        
        let networkOk = isNetworkAvailable()
        let update = try helper.hasUpdate()
        
        let hasUpdate = update.hasUpdate
        
        if (hasUpdate && networkOk) {
            // Get from WS
            var ws : [V.T] = []
            ws = try helper.getListFromWS(getParams(params))
            LogUtils.log("list: \(ws.count) objects")
            
            if ws.isEmpty {
                return []
            }
            
            LogUtils.log("refresh delete all")
            helper.deleteAllBeforeRefresh(getParams(params))
            
            // Save BD
            LogUtils.log("save: \(ws.count) objects")
            helper.save(ws, params: params)
            
            // Save Version
            if (hasUpdate && ws.count > 0) {
                LogUtils.log("<< Save appVersion: \(update)")
                try helper.setUpdated(update)
            }
            
            LogUtils.log("<< SyncService.list: \(ws.count) objects")
            return ws
            
        } else {
            // BD
            var bd : [V.T] = []
            bd = try helper.getListFromDB(getParams(params))
            
            LogUtils.log("<< bd: \(bd.count) objects")
            return bd
        }
    }
    
    //MARK: - List
    
    open static func list<V: SyncHelper>(_ helper: V, params: [String: AnyObject]) throws -> [V.T] where V.T: Entity {
        return try listForce(helper, params: params, forceUpdate: false)
    }
    
    open static func listForce<V: SyncHelper>(_ helper: V, params: [String: AnyObject], forceUpdate: Bool) throws -> [V.T] where V.T: Entity {
        var list : [V.T] = []
        let syncMode = helper.getSyncMode()
        
        if (syncMode == .version) {
            list = try listVersion(helper, params: params, forceUpdate: forceUpdate)
        } else if (syncMode == .online_FIRST) {
            list = try listOnlineFirst(helper, params: params)
        } else if (syncMode == .offline_FIRST) {
            list = try listOfflineFirst(helper, params: params, forceUpdate: forceUpdate)
        }
        
        return list
    }
}
