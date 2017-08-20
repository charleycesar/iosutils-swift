//
//  DateUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 04/07/2016.
//
//

import UIKit

open class DateUtils: NSObject {
    
    /*
    //MARK: - String
    
    static open func getDate(_ date: Date? = Date(), withPattern pattern: String = "dd/MM/yyyy") -> String {
        return toString(date, withPattern: pattern)
    }
    
    static open func toString(_ date: Date?, withPattern pattern: String = "dd/MM/yyyy") -> String {
        let string = date?.toString(.Custom(pattern))
        return string ?? ""
    }
    
    //MARK: - Date
    
    static open func getDate(_ year: Int, andMonth month: Int, andDay day: Int) -> Date {
        let date = Date(refDate: Date(), year: year, month: month, day: day, region: UIRegion.UTCRegion())
        return date
    }
    
    static open func toDate(_ dateString: String?, withPattern pattern: String = "dd/MM/yyyy") -> Date? {
        let date = dateString?.toDate(.Custom(pattern))
        return date
    }
    
    //MARK: - Comparison
    
    static open func compareTo(_ dateA: Date?, andDate dateB: Date?, ignoreTime: Bool = false) -> Int {
        guard let firstDate = dateA else {
            return dateB == nil ? 0 : -1
        }
        
        guard let secondDate = dateB else {
            return dateA == nil ? 0 : 1
        }
        
        if !ignoreTime {
            if (firstDate == secondDate) {
                return 0
            } else if (firstDate < secondDate) {
                return -1
            } else if (firstDate > secondDate) {
                return 1
            }
        }
        
        let stringFirstDate = toString(firstDate, withPattern: "yyyyMMdd")
        let stringSecondDate = toString(secondDate, withPattern: "yyyyMMdd")
        
        let result = stringFirstDate.compare(stringSecondDate)
        
        switch result {
            case .orderedSame:
                return 0
            case .orderedAscending:
                return -1
            case .orderedDescending:
                return 1
        }
    }
    
    static open func equals(_ dateA: Date?, andDate dateB: Date?, ignoreTime: Bool = false) -> Bool {
        return compareTo(dateA, andDate: dateB, ignoreTime: ignoreTime) == 0
    }
    
    static open func isBefore(_ dateA: Date?, thanDate dateB: Date?, ignoreTime: Bool = false) -> Bool {
        return compareTo(dateA, andDate: dateB, ignoreTime: ignoreTime) < 0
    }
    
    static open func isAfter(_ dateA: Date?, thanDate dateB: Date?, ignoreTime: Bool = false) -> Bool {
        return compareTo(dateA, andDate: dateB, ignoreTime: ignoreTime) > 0
    }
    
    static open func isWeekday(_ date: Date?) -> Bool {
        return !isWeekend(date)
    }
    
    static open func isWeekend(_ date: Date?) -> Bool {
        guard let date = date else {
            return false
        }
        
        let isWeekend = date.isWeekend() ?? false
        return isWeekend
    }
    
    static open func isDate(_ string: String?, withPattern pattern: String = "dd/MM/yyyy") -> Bool {
        
        let date = toDate(string, withPattern: pattern)
        return date != nil
    }
    
    //MARK: - Formatting
    
    static open func lowDateTime(_ date: Date) -> Date {
        let zeroTimeDate = date.startOf(.Day, inRegion: Region.UTCRegion())
        return zeroTimeDate
    }
    
    static open func highDateTime(_ date: Date) -> Date {
        let maxTimeDate = date.endOf(.Day, inRegion: Region.UTCRegion())
        return maxTimeDate
    }
    
    //MARK: - Getters
    
    static open func getDay(_ date: Date?) -> Int {
        
        guard let date = date else {
            return 0
        }
        
        return date.day
    }
    
    static open func getMonth(_ date: Date?) -> Int {
        
        guard let date = date else {
            return 0
        }
        
        return date.month
    }
    
    static fileprivate func getMonthSymbols(_ date: Date, withLocaleIdentifier localeIdentifier: String, shortFormat: Bool) -> [String] {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        
        let months = shortFormat ? formatter.shortMonthSymbols : formatter.monthSymbols
        return months!
    }
    
    static open func getMonthString(_ date: Date?, withLocaleIdentifier localeIdentifier: String = "pt_BR") -> String {
        
        guard let date = date else {
            return ""
        }
        
        let months = getMonthSymbols(date, withLocaleIdentifier: localeIdentifier, shortFormat: true)
        let index = date.month - 1
        
        guard index < months.count else {
            return ""
        }
        
        return months[index]
    }
    
    static open func getFullMonthString(_ date: Date?, withLocaleIdentifier localeIdentifier: String = "pt_BR") -> String {
        
        guard let date = date else {
            return ""
        }
        
        let months = getMonthSymbols(date, withLocaleIdentifier: localeIdentifier, shortFormat: false)
        let index = date.month - 1
        
        guard index < months.count else {
            return ""
        }
        
        return months[index]
    }
    
    static open func getYear(_ date: Date?) -> Int {
        
        guard let date = date else {
            return 0
        }
        
        return date.year
    }
    
    static open func getComponentsFromDate(_ date: Date?, ignoreTime: Bool = false) -> DateComponents {
        
        var components = DateComponents()
        
        guard let date = date else {
            return components
        }
        
        components.era = date.era
        components.year = date.year
        components.month = date.month
        components.day = date.day
        components.weekday = date.weekday
        components.weekOfMonth = date.weekOfMonth
        components.weekOfYear = date.weekOfYear
        components.yearForWeekOfYear = date.yearForWeekOfYear
        
        if !ignoreTime {
            components.hour = date.hour
            components.minute = date.minute
            components.second = date.second
            components.nanosecond = date.nanosecond
        }
        
        return components
    }
    
    static open func getHoursDifference(_ startDate: Date?, fromDate endDate: Date?) -> Int {
        
        guard let startDate = startDate else {
            return 0
        }
        
        guard let endDate = endDate else {
            return 0
        }
        
        let result = endDate.hoursFrom(startDate)
        return result < 0 ? -result : result
    }
    
    static open func getDaysDifference(_ startDate: Date?, fromDate endDate: Date?) -> Int {
        guard let startDate = startDate else {
            return 0
        }
        
        guard let endDate = endDate else {
            return 0
        }
        
        let result = endDate.daysFrom(startDate)
        return result < 0 ? -result : result
    }
    
    static open func getNumberOfDaysInMonth(_ month: Int, ofYear year: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = Calendar.current
        
        guard let date = calendar.date(from: dateComponents) else {
            return 0
        }
        
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: date)
        return range.length
    }
    
    static open func getIdade(_ birthDate: Date?) -> Idade {
        
        guard let birthDate = birthDate else {
            return Idade(days: 0, months: 0, years: 0)
        }
        
        let now = Date()
        
        var years = now.yearsFrom(birthDate)
        
        var months = now.month - birthDate.month
        
        //if month difference is negative then reduce years by one and calculate the number of months
        if (months < 0) {
            years -= 1
            months = 12 - birthDate.month + now.month
            
            if (now.day < birthDate.day) {
                months -= 1
            }
        } else if (months == 0 && now.day < birthDate.day) {
            years -= 1
            months = 11
        }
        
        var days = 0
        
        //calculate the days
        if (now.day > birthDate.day) {
            days = now.day - birthDate.day
            
        } else if (now.day < birthDate.day) {
            days = getNumberOfDaysInMonth(birthDate.month, ofYear: birthDate.year) - birthDate.day + now.day
            
        } else {
            days = 0
            
            if (months == 12) {
                years += 1
                months = 0
            }
        }
        
        return Idade(days: days, months: months, years: years)
    }
 */
}
