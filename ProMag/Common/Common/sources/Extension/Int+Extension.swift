//
//  Int+Extension.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public extension Int {
    func toString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
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
}
