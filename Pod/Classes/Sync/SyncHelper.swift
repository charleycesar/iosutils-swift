//
//  SyncHelper.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 08/04/2016.
//
//

import Foundation

public protocol SyncHelper {
    
    associatedtype T
    
    func hasUpdate() throws -> SyncUpdate
    
    func setUpdated(_ update: SyncUpdate) throws
    
    func getDomainClass() -> AnyClass
    
    func getListFromWS(_ params: [String: AnyObject]) throws -> [T]
    
    func getListFromDB(_ params: [String: AnyObject]) throws -> [T]
    
    func save(_ list: [T], params: [String: AnyObject])
    
    func getSyncMode() -> SyncMode
    
    func deleteAllBeforeRefresh(_ params: [String: AnyObject])
    
    func postDeleteWs(_ list: [T], params: [String: AnyObject]) throws -> [Int]
    
    func postSaveWs(_ list: [T], params: [String: AnyObject]) throws -> [Int]
}
