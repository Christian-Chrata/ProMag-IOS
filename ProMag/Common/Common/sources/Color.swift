//
//  Color.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public enum ColorType: Int {
    case primary // 0
    case secondary // 1
    case disable // 2
    case danger // 3
    case warning // 4
    case success // 5
    
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return Color.primary
        case .secondary:
            return Color.white
        case .disable:
            return Color.disable
        case .danger:
            return Color.danger
        case .warning:
            return Color.warning
        case .success:
            return Color.success
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .secondary:
            return Color.primary
        default:
            return Color.white
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .secondary:
            return 2
        default:
            return 0
        }
    }
}

public enum Color {
    public static var primary = UIColor(red: 87/255, green: 155/255, blue: 177/255, alpha: 1.0)
    public static var label = UIColor(red: 35/255, green: 31/255, blue: 32/255, alpha: 1.0)
    public static var white = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1.0)
    public static var disable = UIColor(red: 143/255, green: 140/255, blue: 139/255, alpha: 1.0)
    public static var danger = UIColor(red: 223/255, green: 105/255, blue: 90/255, alpha: 1.0)
    public static var warning = UIColor(red: 245/255, green: 181/255, blue: 70/255, alpha: 1.0)
    public static var success = UIColor(red: 137/255, green: 184/255, blue: 168/255, alpha: 1.0)
}
