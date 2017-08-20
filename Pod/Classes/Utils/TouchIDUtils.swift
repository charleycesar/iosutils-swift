//
//  TouchIDUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 04/07/2016.
//
//

import UIKit

import LocalAuthentication

open class TouchIDUtils: NSObject {
    
    ///Não esquecer importar o módulo LocalAuthentication para usar o método scanFingerprint.
    
    //MARK: - Evaluation
    
    static fileprivate func canEvaluateWithContext(_ context: LAContext) throws -> Bool {
        var error : NSError?
        
        if !context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //TODO
            if let error = error {
                throw error
            }
            
            return false
        }
        
        return true
    }
    
    static open func evaluateWithContext(_ context: LAContext, withTitle title: String, onSuccess: @escaping (() -> Void), andOnError onError: ((_ error: LAError.Code) -> Void)?) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: title, reply: { (success: Bool, error:NSError?) in
            
            if success {
                DispatchQueue.main.async(execute: {
                    onSuccess()
                })
            } else if let error = error as? LAError.Code {
                DispatchQueue.main.async(execute: {
                    onError?(error)
                })
            }
        } as! (Bool, Error?) -> Void)
    }
    
    //MARK: - Hardware
    
    /**
     *  Retorna se o dispositivo possui a funcionalidade Touch ID.
     */
    static open func isAvailable() -> Bool {
        do {
            return try canEvaluateWithContext(LAContext())
            
        } catch let error as LAError.Code {
            if (error == LAError.Code.touchIDNotAvailable) {
                return false
            }
        } catch {}
        
        return true
    }
    
    //MARK: - Register
    
    /**
     *  Retorna se o usuário já registrou alguma digital no dispositivo.
     */
    static open func isFingerprintEnrolled() -> Bool {
        do {
            return try canEvaluateWithContext(LAContext())
            
        } catch let error as LAError.Code {
            if (error == LAError.Code.touchIDNotEnrolled) {
                return false
            }
        } catch {}
        
        return true
    }
    
    //MARK: - Scan
    
    static open func scanFingerprint(_ title: String = "Touch ID", onSuccess: @escaping (() -> Void), andOnError onError: ((_ error: LAError.Code) -> Void)? = nil) {
        let context = LAContext()
        
        do {
            if (try canEvaluateWithContext(context)) {
                evaluateWithContext(context, withTitle: title, onSuccess: onSuccess, andOnError: onError)
            }
        } catch {
            if let error = error as? LAError.Code {
                onError?(error)
            }
        }
    }
}
