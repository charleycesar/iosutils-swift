//
//  iOSUtils.swift
//  Pods
//
//  Created by Livetouch on 21/06/16.
//
//

import UIKit
import SystemConfiguration
import AudioToolbox

/*
 *  Não adicionar novos métodos nesta classe.
 *  Além de ser uma classe muito genérica (iOSUtils), já existem classes que fazem algumas dessas funcionalidades.
 *  Ex.: AppUtils, NetworkUtils, OrientationUtils etc.
 *
 *  Os métodos aqui implementados que não se encontram em outras classes, devem ser passados para outras classes. Caso necessário, crie uma nova classe. O nome fica a seu critério e risco.
 */

open class iOSUtils: NSObject {
    
    @available(*, deprecated: 1.1.15, message: "Use DeviceUtils.getUUID() instead.")
    open static func getUDID() -> String {
        let newUniqueID = CFUUIDCreate(kCFAllocatorDefault)
        let newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
        let guid = newUniqueIDString as! String
        
        return guid.lowercased()
    }
    
    @available(*, deprecated: 1.1.15, message: "Use AppUtils.getVersion() instead.")
    open static func getVersionCode() throws -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    
    /**
    * Retorna se existe conexão com a internet ou não
    */
    @available(*, deprecated: 1.1.15, message: "Use NetworkUtils.isAvailable() instead.")
    open class func isNetworkAvailable() -> Bool {
        /*var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
 */
        return NetworkUtils.isAvailable()
    }
    
    @available(*, deprecated: 1.1.15, message: "Use DeviceUtils.vibrate() instead.")
    open static func vibrar() throws {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    @available(*, deprecated: 1.1.15, message: "Use OrientationUtils.isLandscape() instead.")
    open static func isHorizontal() throws -> Bool {
        return (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft) || (UIDevice.current.orientation == UIDeviceOrientation.landscapeRight)
    }
    
    @available(*, deprecated: 1.1.15, message: "Use OrientationUtils.isPortrait() instead.")
    open static func isVertical() throws -> Bool {
        return (UIDevice.current.orientation == UIDeviceOrientation.portrait) || (UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown)
    }
    
    

}
