//
//  DeviceUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 17/06/2016.
//
//

import Foundation

import AudioToolbox

open class DeviceUtils: NSObject {
    
    //MARK: - Helpers
    
    static fileprivate func getDigitsOnlyPhoneNumber(_ phoneNumber: String) -> String {
        let numberArray = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let number = numberArray.joined(separator: "")
        return number
    }
    
    //MARK: - Actions
    
    static open func call(_ phoneNumber: String) {
        let number = getDigitsOnlyPhoneNumber(phoneNumber)
        if let nsurl = URL(string: "tel://\(number)") {
            UIApplication.shared.openURL(nsurl)
        }
    }
    
    static open func sms(_ phoneNumber: String) {
        let number = getDigitsOnlyPhoneNumber(phoneNumber)
        if let nsurl = URL(string: "sms://\(number)") {
            UIApplication.shared.openURL(nsurl)
        }
    }
    
    static open func openSettings() {
        if let nsurl = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(nsurl)
        }
    }
    
    static open func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    //MARK: - Information
    
    /**
     * Retorna o UDID para identificar o celular
     */
    static open func getUUID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    static open func getPlatformCode() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let platform = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return platform
    }
    
    static open func getName() -> String {
        let model = getPlatformCode()
        let version = "\(getVersion())"
        let uniqueIdentifier = getUUID()
        
        var name = "\(model)_\(version)_\(uniqueIdentifier)"
        name = StringUtils.replace(name, inQuery: ",", withReplacement: ".")
        name = StringUtils.replace(name, inQuery: "-", withReplacement: "_")
        
        return name
    }
    
    //MARK: - Clipboard
    
    static open func copyToClipboard(_ text: String?) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }
    
    //MARK: - Sizes
    
    static open func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    static open func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static open func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    //MARK: - Scales
    
    static open func getScreenScale() -> CGFloat {
        return UIScreen.main.scale
    }
    
    static open func isNormalDisplay() -> Bool {
        let version = getVersion()
        if (version < 4.0) {
            return false
        }
        
        let scale = getScreenScale()
        return scale == 1.0
    }
    
    static open func isRetinaDisplay() -> Bool {
        let version = getVersion()
        if (version < 4.0) {
            return false
        }
        
        let scale = getScreenScale()
        return scale == 2.0
    }
    
    static open func isHDDisplay() -> Bool {
        let version = getVersion()
        if (version < 4.0) {
            return false
        }
        
        let scale = getScreenScale()
        return scale == 3.0
    }
    
    //MARK: - Model
    
    static open func getModel() -> String  {
        return UIDevice.current.model
    }
    
    static open func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static open func isIphone() -> Bool {
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .phone
    }
    
    static open func isIpad() -> Bool {
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .pad
    }
    
    static open func isIphone4() -> Bool {
        if isIpad() {
            return false
        }
        
        let screenHeight = getScreenHeight()
        return screenHeight == 480.0
    }
    
    static open func isIphone5() -> Bool {
        if isIpad() {
            return false
        }
        
        let screenHeight = getScreenHeight()
        return screenHeight == 568.0
    }
    
    static open func isIphone6() -> Bool {
        if isIpad() {
            return false
        }
        
        let screenHeight = getScreenHeight()
        return screenHeight == 667.0
    }
    
    static open func isIphone6Plus() -> Bool {
        if isIpad() {
            return false
        }
        
        let screenHeight = getScreenHeight()
        return screenHeight == 736.0
    }
    
    //MARK: - Version
    //TODO
    static open func getVersion() -> Float {
        return Float(UIDevice.current.systemVersion)!
    }
    
    static open func isIOS8() -> Bool {
        let version = getVersion()
        return version >= 8.0
    }
    
    static open func isIOS9() -> Bool {
        let version = getVersion()
        return version >= 9.0
    }
    
    static open func isIOS10() -> Bool {
        let version = getVersion()
        return version >= 10.0
    }
}
