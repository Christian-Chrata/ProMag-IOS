//
//  Date+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public extension Date {
    // MARK: Default date format is use UTC we need convert to local to make sure date use local timezone
    func toString(dateFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_us")
        return formatter.string(from: self)
    }
    
    func convert( from initialFormat: String, to targetFormat: String? = nil) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = initialFormat
        formatter.locale = Locale(identifier: "en_us")
        formatter.timeZone   = TimeZone(abbreviation: "GMT")
        
        if targetFormat != nil {
                formatter.dateFormat = targetFormat
            }
        
        return formatter.string(from: self)
    }
    
    func dateconvertMo ( ) -> Date? {

        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

      
        return localDate
    }
    
    var millisecondsSince1970: Int64 {
             Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        }
            
        init(milliseconds: Int64) {
            self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
        }
    
}

public extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
