//
//  CryptoUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 29/06/2016.
//
//

import UIKit

//import CryptoSwift

open class CryptoUtils: NSObject {
    
    //MARK: - AES
    
//    static open func toAES(_ stringToEncrypt: String?, withKey key: String, andBlockMode blockMode: BlockMode = .ECB) -> String {
//        guard let stringToEncrypt = stringToEncrypt else {
//            return ""
//        }
//        
//        do {
//            guard let input = stringToEncrypt.data(using: String.Encoding.utf8) else {
//                return ""
//            }
//            
//            let encrypted = try input.encrypt(cipher: AES(key: Array(key.utf8), blockMode: blockMode))
//            
//            if let result = String(data: encrypted, encoding: String.Encoding.utf8) {
//                return result
//            }
//        } catch {
//            LogUtils.log("AES Error.")
//        }
//        
//        return ""
//    }
//    
//    static open func fromAES(_ stringToDecrypt: String?, withKey key: String, andBlockMode blockMode: BlockMode = .ECB) -> String {
//        guard let stringToDecrypt = stringToDecrypt else {
//            return ""
//        }
//        
//        do {
//            guard let input = stringToDecrypt.data(using: String.Encoding.utf8) else {
//                return ""
//            }
//            
//            let decrypted = try input.decrypt(cipher: AES(key: Array(key.utf8), blockMode: blockMode))
//            
//            if let result = String(data: decrypted, encoding: String.Encoding.utf8) {
//                return result
//            }
//        } catch {
//            LogUtils.log("AES Error.")
//        }
//        
//        return ""
//    }
//    
//    static open func toSHA256(_ stringToEncrypt: String?, withKey key: String) -> String {
//        guard let stringToEncrypt = stringToEncrypt else {
//            LogUtils.log("SHA-256 Error. String nula.")
//            return ""
//        }
//        
//        let encrypted = stringToEncrypt.sha256()
//        return encrypted
//    }
}
