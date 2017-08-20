//
//  NetworkUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 21/06/2016.
//
//

import UIKit
import SystemConfiguration
import AudioToolbox
//TODO
open class NetworkUtils: NSObject {
    
    static open func isAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    /*
    static open func isWiFiAvailable() -> Bool {
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            let remoteHostStatus = reachability.currentReachabilityStatus
            
            if (remoteHostStatus == .reachableViaWiFi) {
                return true
            }
            
            return false
            
        } catch {
            return false
        }
    }
 */
    /*
    static open func isMobileAvailable() -> Bool {
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            let remoteHostStatus = reachability.currentReachabilityStatus
            
            if (remoteHostStatus == .reachableViaWWAN) {
                return true
            }
            
            return false
            
        } catch {
            return false
        }
    }
 */
}
