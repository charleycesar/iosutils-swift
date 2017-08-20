//
//  ExceptionUtils.swift
//  Pods
//
//  Created by Livetouch BR on 6/22/16.
//
//

import UIKit

open class ExceptionUtils: NSObject {
    
    //MARK: - Get Messages
    
    static open func getExceptionMessage(_ exception: Exception) -> String {
        
        var exceptionTag = ""
        
        switch exception {
            case .ioException:
                exceptionTag = "io_error"
                
            case .networkUnavailableException:
                exceptionTag = "network_unavailable_error"
                
            case .genericException(let message):
                if (StringUtils.isNotEmpty(message)) {
                    return message
                }
                exceptionTag = "generic_error"
            
            default:
                break
        }
        
        return FileUtils.getUtilsDefaultMessage(tag: exceptionTag)
    }
    
    static open func getDBExceptionMessage(_ exception: Error) -> String {
        var errorMessage = ""
        
        switch exception {
            case Exception.notImplemented:
                errorMessage = "AppDelegate não é subclasse de BaseAppDelegate."
                
            case SQLException.databaseHelperNotFound:
                errorMessage = "Não foi encontrado uma subclasse de DatabaseHelper."
                
            case SQLException.notImplemented(let message):
                errorMessage = "Não foi implementado o método '\(message)' na subclasse de DatabaseHelper."
                
            default:
                break
        }
        
        return errorMessage
    }
    
    static open func getIOExceptionMessage() -> String {
        return getExceptionMessage(.ioException)
    }
    
    static open func getGenericMessage() -> String {
        return getExceptionMessage(.genericException(message: ""))
    }
    
    static open func getAppTransportSecurityMessage() -> String {
        return "Configure o atributo 'NSAppTransportSecurity' no seu Info.plist."
    }
    
    //MARK: - Alert Messages
    
    static open func alertException(_ exception: Error) {
        guard let exception = exception as? Exception else {
            return
        }
        
        let message = getExceptionMessage(exception)
        if message.isNotEmpty {
            AlertUtils.alert(message)
        }
    }
    
    static open func alertIOException() {
        AlertUtils.alert(getIOExceptionMessage())
    }
    
    static open func alertGenericException() {
        AlertUtils.alert(getGenericMessage())
    }
    
    static open func alertAppTransportSecurityException() {
        AlertUtils.alert(getAppTransportSecurityMessage())
    }
}
