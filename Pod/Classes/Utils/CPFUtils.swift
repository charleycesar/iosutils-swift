//
//  CPFUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 21/06/2016.
//
//

import UIKit

public class CPFUtils: NSObject {
    
    //MARK: - Mask
    
    /**
     Remove máscara de um CPF.
     
     - important: Exemplo de resultado: 12345670089
     
     - Parameters:
        - string: O CPF na qual será removido a máscara.
     
     - Returns: O CPF sem a máscara.
     */
    static public func unmask(string: String?) -> String {
        guard let string = string else {
            return ""
        }
        
        
        
        //return string.stringByReplacingOccurrencesOfString(".", withString: "").stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString("/", withString: "").stringByReplacingOccurrencesOfString("(", withString: "").stringByReplacingOccurrencesOfString(")", withString: "")
        
        return string.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }
    
    /**
     Adiciona máscara de um CPF.
     
     - important: Exemplo de resultado: 123.456.700-89
     
     - Parameters:
        - string: O CPF na qual será adicionado a máscara.
     
     - Returns: O CPF com a máscara.
     */
    /*
    static public func mask(string: String?) -> String {
        guard let string = string , string.isNotEmpty else {
            return ""
        }
        
        let cpf = unmask(string: string)
        if (cpf.length != 11) {
            return ""
        }
        
        let cpfMasked = cpf.substringFromIndex(startIndex: 0, toIndex: 2) + "." + cpf.substringFromIndex(startIndex: 3, toIndex: 5) + "." + cpf.substringFromIndex(startIndex: 6, toIndex: 8) + "-" + cpf.substringFromIndex(startIndex: 9, toIndex: 10)
        
        return cpfMasked
    }*/
    
    /**
     Verifica se um CPF está com máscara.
    
     - Parameters:
        - string: O CPF na qual será verificado.
    
     - Returns: Verdadeiro se o CPF está com máscara e Falso caso o contrário.
    */
    static public func isMasked(string: String?) -> Bool {
        if let string = string {
            return string.contains(".")
        }
        return false
    }
    
    //MARK: - Validation
    
    /**
     Verifica se um possível CPF é válido.
     
     - Parameters:
        - string: O CPF na qual será validado.
     
     - Returns: Verdadeiro se a string é válida como CPF ou Falso caso o contrário.
     */
    static public func isValid(string: String?) -> Bool {
        /*guard let string = string , string.isNotEmpty else {
            return false
        }
        
        let cpf = CPFUtils.unmask(string: string)
        if (cpf.length != 11) {
            return false
        }
        
        var primeiroDigitoVerificador = ""
        var segundoDigitoVerificador = ""
        
        var j = 0
        var sum = 0
        var result = 0
        
        for weight in 10.stride(to: 1, by: -1) {
            let substring = cpf[cpf.startIndex.advancedBy(j)]
            let segment = String(substring).utf8
            
            sum += weight * ("\(segment)".integerValue)
            j += 1
        }
        
        result = 11 - (sum % 11)
        if (result == 10 || result == 11) {
            primeiroDigitoVerificador = "0"
        } else {
            primeiroDigitoVerificador.append(UnicodeScalar(result + 48)!)
        }
        
        let penultimoDigito = cpf.substringWith(cpf.startIndex.advancedBy(9)...cpf.endIndex.advancedBy(-2))
        if (!primeiroDigitoVerificador.equalsIgnoreCase(penultimoDigito)) {
            return false
        }
        
        j = 0
        sum = 0
        
        for weight in 11.stride(to: 1, by: -1) {
            let substring = cpf[cpf.startIndex.advancedBy(j)]
            let segment = String(substring).utf8
            
            sum += weight * ("\(segment)".integerValue)
            j += 1
        }
        
        result = 11 - (sum % 11)
        if (result == 10 || result == 11) {
            segundoDigitoVerificador = "0"
        } else {
            segundoDigitoVerificador.append(UnicodeScalar(result + 48)!)
        }
        
        let ultimoDigito = cpf.substringWith(cpf.startIndex.advancedBy(10)...cpf.endIndex.advancedBy(-1))
        if (!segundoDigitoVerificador.equalsIgnoreCase(ultimoDigito)) {
            return false
        }*/
        
        return false
    }
}
