//
//  UITextfield+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public extension UITextField {
    func value() -> String {
        guard let text = text else { return "" }
        return text.trimmingCharacters(in: .whitespaces)
    }
}
