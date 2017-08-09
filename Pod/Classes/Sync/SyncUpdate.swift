//
//  SyncUpdate.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 12/04/2016.
//
//

import UIKit

open class SyncUpdate: NSObject {
    
    //MARK: - Variables
    
    open var hasUpdate    : Bool
    
    open var appVersion   : Int
    open var serverVersion: Int
    
    //MARK: - Inits
    
    override public init() {
        hasUpdate = false
        appVersion = -1
        serverVersion = -1
    }
    
    //MARK: Class Methods
    
    open static func No() -> SyncUpdate {
        let syncUpdate = SyncUpdate()
        syncUpdate.hasUpdate = false
        
        return syncUpdate
    }
    
    open static func Yes(appVersion: Int, serverVersion: Int) -> SyncUpdate {
        let syncUpdate = SyncUpdate()
        syncUpdate.hasUpdate = true
        syncUpdate.appVersion = appVersion
        syncUpdate.serverVersion = serverVersion
        
        return syncUpdate
    }
}
