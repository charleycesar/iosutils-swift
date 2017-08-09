//
//  Idade.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 04/07/2016.
//
//

import UIKit

open class Idade: NSObject {
    
    //MARK: - Variables
    
    fileprivate var days    : Int
    fileprivate var months  : Int
    fileprivate var years   : Int
    
    //MARK: - Inits
    
    public init(days: Int, months: Int, years: Int) {
        self.days = days
        self.months = months
        self.years = years
    }
    
    //MARK: - Description
    
    open override var description: String {
        return "\(years) years, \(months) months, \(days) days"
    }
    
    //MARK: - Getters
    
    open func getDays() -> Int {
        return days
    }
    
    open func getMonths() -> Int {
        return months
    }
    
    open func getYears() -> Int {
        return years
    }
    
    //MARK: - Helpers
    
    open func toString() -> String {
        return "\(years) Years, \(months) Months, \(days) Days"
    }
}
