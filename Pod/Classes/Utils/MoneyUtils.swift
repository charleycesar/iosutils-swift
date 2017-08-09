//
//  MoneyUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

open class MoneyUtils: NSObject {
    
    //MARK: - Formatter
    
    static open func getFormatter(localeIdentifier: String = "", maximumDigits: Int = 2, symbol: String = "") -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol
        formatter.maximumFractionDigits = maximumDigits
        
        if (StringUtils.isNotEmpty(localeIdentifier)) {
            formatter.locale = Locale(identifier: localeIdentifier)
        }
        
        return formatter
    }
    
    static open func getReaisFormatter(maximumDigits: Int = 2, showSymbol: Bool = false) -> NumberFormatter {
        let symbol = showSymbol ? "R$ " : ""
        let formatter = getFormatter(localeIdentifier: "pt_BR", maximumDigits: maximumDigits, symbol: symbol)
        return formatter
    }
    
    static open func getDollarFormatter(maximumDigits: Int = 2, showSymbol: Bool = false) -> NumberFormatter {
        let symbol = showSymbol ? "US$ " : ""
        let formatter = getFormatter(localeIdentifier: "en_US", maximumDigits: maximumDigits, symbol: symbol)
        return formatter
    }
    
    //MARK: - Reais
    
    static open func formatReais(_ value: Double, maximumDigits: Int = 2, showSymbol: Bool = false) -> String {
        let formatter = getReaisFormatter(maximumDigits: maximumDigits, showSymbol: showSymbol)
        
        if let string = formatter.string(from: NSNumber(value: value))  {
            return string
        }
        
        return ""
    }
    
    static open func formatReaisString(_ string: String?, maximumDigits: Int = 2, showSymbol: Bool = false) -> String {
        guard let string = string else {
            return ""
        }
        
        let formattedString = formatReais(string.doubleValue, maximumDigits: maximumDigits, showSymbol: showSymbol)
        
        return formattedString
    }
    
    //MARK: - Dólar
    
    static open func formatDollar(_ value: Double, maximumDigits: Int = 2, showSymbol: Bool = false) -> String {
        let formatter = getDollarFormatter(maximumDigits: maximumDigits, showSymbol: showSymbol)
        
        if let string = formatter.string(from: NSNumber(value: value)) {
            return string
        }
        
        return ""
    }
    
    static open func formatDollarString(_ string: String?, maximumDigits: Int = 2, showSymbol: Bool = false) -> String {
        guard let string = string else {
            return ""
        }
        
        let formattedString = formatDollar(string.doubleValue, maximumDigits: maximumDigits, showSymbol: showSymbol)
        
        return formattedString
    }
}
