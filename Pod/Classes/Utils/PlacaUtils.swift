//
//  PlacaUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

open class PlacaUtils: NSObject {
    
    //MARK: - Mask
    
    static open func unmask(_ placa: String?) -> String {
        return StringUtils.replace(placa, inQuery: "-", withReplacement: "")
    }
    
    /*@available(*, deprecated: 1.5.1, message: "Usar somente para placas de veículos no formato antigo (AAA-0000).")
    static open func mask(_ placa: String?) -> String {
        guard let placa = placa , StringUtils.isNotEmpty(placa) else {
            return ""
        }
        
        let unmasked = unmask(placa)
        if (unmasked.length != 7) {
            return ""
        }
        
        let masked = "\(placa.substringFromIndex(startIndex: 0, toIndex: 3))-\(placa.substringFromIndex(startIndex: 3, toIndex: 7))"
        return StringUtils.toUpperCase(masked)
    }
    */
    @available(*, deprecated: 1.5.1, message: "Usar somente para placas de veículos no formato antigo (AAA-0000).")
    static open func isMasked(_ placa: String?) -> Bool {
        guard let placa = placa , StringUtils.isNotEmpty(placa) else {
            return false
        }
        
        if (placa.length != 8) {
            return false
        }
        
        return StringUtils.contains(placa, fromQuery: "-")
    }
    
    //MARK: - Validation
    
    /*static open func isValid(_ placa: String?) -> Bool {
        guard let placa = placa , StringUtils.isNotEmpty(placa) else {
            return false
        }
        
        if (StringUtils.contains(placa, fromQuery: "-")) {
            //formato antigo AAA-0000
            
            let unmasked = unmask(placa)
            if (unmasked.length != 7) {
                return false
            }
            
            let letras = placa.substringFromIndex(startIndex: 0, toIndex: 3)
            if (StringUtils.isNotLetters(letras)) {
                return false
            }
            
            let numeros = placa.substringFromIndex(startIndex: 3, toIndex: 7)
            if (StringUtils.isNotDigits(numeros)) {
                return false
            }
            
            return true
        }
        
        //formato novo (Mercosul): total de 7 caracteres com 4 (quatro) letras e 3 (três) números, podendo ser embaralhados
        
        if (placa.length != 7) {
            return false
        }
        
        let letterComponents = placa.components(separatedBy: CharacterSet.letters.inverted)
        let letters = letterComponents.joined(separator: "")
        if (letters.length != 4) {
            return false
        }
        
        let numberComponents = placa.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let numbers = numberComponents.joined(separator: "")
        if (numbers.length != 3) {
            return false
        }
        
        return true
    }*/
}
