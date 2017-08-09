//
//  AppUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 17/06/2016.
//
//

import UIKit

open class AppUtils: NSObject {
    
    //MARK: - Information
    
    /**
     Retorna o nome do build do projeto.
     
     - Returns: O nome do projeto.
     
     */
    static open func getName() -> String {
        let bundle = Bundle.main
        if let displayName = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return displayName
        }
        return ""
    }
    
    /**
     Retorna a versão do build do projeto.
     
     - Returns: String com o número da versão.
     
     */
    static open func getVersion() -> String {
        let bundle = Bundle.main
        if let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return version
        }
        return ""
    }
    
    /**
     Retorna o número do build do projeto.
     
     - important: Equivalente ao getVersionCode() do AndroidUtils.
     
     */
    static open func getBundleNumber() -> String {
        let bundle = Bundle.main
        if let bundleNumber = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return bundleNumber
        }
        return ""
    }
    
    /**
     Retorna se cada `UIViewController` do projeto trata a aparência de sua `UIStatusBar`.
     
     - Returns: Verdadeiro caso o tratamento seja individual, e falso caso contrário.
     
     */
    static open func getViewControllerBasedStatusBarAppearance() throws -> Bool {
        let bundle = Bundle.main
        if let vcBased = bundle.object(forInfoDictionaryKey: "UIViewControllerBasedStatusBarAppearance") as? Bool {
            return vcBased
        }
        throw Exception.domainException(message: "Adicione o atributo 'UIViewControllerBasedStatusBarAppearance' no seu Info.plist.")
    }
    
    //MARK: - App Store
    
    /**
     Abre o aplicativo da AppStore brasileira na página passada.
     
     - important: itunes.apple.com/br/app
     
     - parameter appLink:
     */
    static open func openAppStore(_ appLink: String) {
        let appStorePrefix = "itms://itunes.apple.com/br/app/"
        
        var url = appLink
        url = url.replacingOccurrences(of: appStorePrefix, with: "")
        
        if let nsurl = URL(string: "\(appStorePrefix)\(url)") {
            UIApplication.shared.openURL(nsurl)
        }
    }
    
    //MARK: - State
    
    /**
     Retorna o estado de execução da aplicação.
     
     - Returns: UIApplicationState
     */
    static open func getState() -> UIApplicationState {
        return UIApplication.shared.applicationState
    }
    
    /**
     Retorna se a aplicação está ativo, ou seja, está em primeiro plano.
     
     - Returns: Bool = true se .Active
     */
    static open func isActive() -> Bool {
        let state = getState()
        return state == .active
    }
    
    /**
     Retorna se a aplicação está em background.
     
     - Returns: Bool = true se .Background
     */
    static open func isInBackground() -> Bool {
        let state = getState()
        return state == .background
    }
    
    /**
     Retorna se a aplicação está ativo, ou seja, está em primeiro plano.
     
     - Returns: Bool = true se .Active
     */
    static open func isRunning() -> Bool {
        let state = getState()
        return state == .active
    }
}
