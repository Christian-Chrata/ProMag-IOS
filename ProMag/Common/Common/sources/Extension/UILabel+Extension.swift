//
//  UILabel+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public extension UILabel {
    static func buildAttributtedString(with attrs: [Attr]) -> NSAttributedString {
        let attr = NSMutableAttributedString()
        attrs.forEach { (attrs) in
            attr.append(attrs.text.attributedString(font: UIFont.systemFont(ofSize: attrs.size, weight: attrs.weight), color: attrs.color))
        }
        return attr
    }
    
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
