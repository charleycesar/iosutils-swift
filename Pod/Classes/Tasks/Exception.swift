//
//  Exception.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 15/06/2016.
//
//

import Foundation

public enum Exception : Error {
    
    case ioException
    case networkUnavailableException
    case jsonException
    case fileNotFoundException
    case appSecurityTransportException
    case notImplemented
    
    case domainException(message: String)
    case runTimeException(message: String)
    case genericException(message: String)
}
