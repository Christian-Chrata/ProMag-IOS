//
//  Double+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public extension Double {
    func toString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: Double(self))) ?? "0"
    }
    
    func toStringDec() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 3
        return formatter.string(from: NSNumber(value: Double(self))) ?? "0"
    }
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ID")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = "Rp "
        return formatter.string(from: NSNumber(value: self)) ?? "Rp 0"
    }
    
    func toCurrencyDec() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ID")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "Rp "
        return formatter.string(from: NSNumber(value: self)) ?? "Rp 0"
    }
}

public extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
