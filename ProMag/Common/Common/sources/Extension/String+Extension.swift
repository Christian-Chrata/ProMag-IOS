//
//  String+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit
import CommonCrypto

public extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}

public extension String {
    func regex(with pattern: String) -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}

public extension String {
    func attributedString(font: UIFont, color: UIColor) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        return NSAttributedString(string: self, attributes: attributes)
    }

    func attributedString(font: UIFont, color: UIColor, lineHeight: CGFloat) -> NSAttributedString {
        let text = self.attributedString(font: font, color: color)
        let attributedString = NSMutableAttributedString()
        attributedString.append(text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    static func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
}

public extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

public extension String {
    var htmlToAttributedString: NSAttributedString? {
        return htmlToAttributedString(color: UIColor.black, font: UIFont.systemFont(ofSize: 14))
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func htmlToAttributedString(color: UIColor, font: UIFont) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
            "html *" +
            "{" +
            "font-size: \(font.pointSize)px;" +
            "color: \(color.toHex() ?? "#000000");" +
            "font-family: -apple-system;" +
            "}</style> \(self)"
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}

public extension String {
    // MARK: Convert String date from backend (UTC) to Local
    func toDate(dateFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ID")
        return formatter.date(from: self)
    }
    
    
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ID")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = "Rp "
        return formatter.string(from: NSNumber(value: Double(self) ?? 0)) ?? "Rp 0"
    }
    
    func convert(dateFormatFrom from : String,dateFormatTo to : String? = nil) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = from
        formatter.locale = Locale(identifier: "en_us")
        formatter.timeZone   = TimeZone(abbreviation: "GMT")
        guard let date = formatter.date(from: self) else { return nil }
        
        if let newFormat = to {
            formatter.dateFormat = newFormat
        }
       
        return date
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0
    }
}

public extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
}

public extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                return ($0 + " " + String($1))
            }
            else {
                return $0 + String($1)
            }
        }
    }
}
