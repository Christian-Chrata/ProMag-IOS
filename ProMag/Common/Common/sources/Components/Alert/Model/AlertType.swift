//
//  AlertType.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public enum AlertType {
    case success(title: String = "Congratulations", message: String)
    case failure(title: String = "Uh Oh", message: String)
    case warning(title: String = "Hmmm", message: String)
    
    var color: UIColor? {
        switch self {
        case .success:
            return Color.success
        case .failure:
            return Color.danger
        case .warning:
            return Color.warning
        }
    }
    
    var title: String {
        switch self {
        case .success(let title, _):
            return title
        case .failure(let title, _):
            return title
        case .warning(let title, _):
            return title

        }
    }
    
    var message: String {
        switch self {
        case .success(_, let message):
            return message
        case .failure(_, let message):
            return message
        case .warning(_, let message):
            return message
        }
    }
    
    var image: UIImage? {
        switch self {
        case .success:
            return UIImage(named: "success", in: Bundle(identifier: "com.chrata.Common"), compatibleWith: nil)
        case .failure:
            return UIImage(named: "failure", in: Bundle(identifier: "com.chrata.Common"), compatibleWith: nil)
        case .warning:
            return UIImage(named: "warning", in: Bundle(identifier: "com.chrata.Common"), compatibleWith: nil)
        }
    }
}

