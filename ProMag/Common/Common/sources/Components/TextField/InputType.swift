//
//  InputType.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

public enum InputType {
    case text
    case name
    case number
    case email
    case phone
    case pass
    case loginPass
    case dropdown
    
    public var regex: String {
        switch self {
        case .text:
            return "^.{1,}$"
        case .name:
            return "^[A-Za-z]{1,}$"
        case .number:
            return "^[0-9]+$"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .phone:
            return "^(62)([0-9]{8,13})$"
        case .pass:
            return "^(?=.*\\d)(?=.*\\D)([a-zA-Z0-9]{8,})$"
        case .loginPass:
            return "^.{8,}$"
        case .dropdown:
            return "^(.{1,})$"
        }
    }
    
    public var error: String {
        switch self {
        case .text:
            return "Is required"
        case .name:
            return "Text should be an alphabet"
        case .number:
            return "Wrong Format"
        case .email:
            return "You need to use email format (EX: user@mail.com)"
        case .phone:
            return "You need to use Indonesian phone number format(EX: 6212345)"
        case .pass:
            return "Password must contains alphanumeric and 8 character"
        case .loginPass:
            return "Wrong Format"
        case .dropdown:
            return "Wrong Format"
        }
    }
}

public struct UserDataModel {
    public var value: String
    public var enabled: Bool
    public let type: InputType
    public var isRequired: Bool
    public var placeholder: String
    
    public init(value: String, enabled: Bool, type: InputType, isRequired: Bool, placeholder: String) {
        self.value = value
        self.enabled = enabled
        self.type = type
        self.isRequired = isRequired
        self.placeholder = placeholder
    }
    
    public func isValid() -> Bool {
        let value = value.trimmingCharacters(in: .whitespaces)
        if value.isEmpty {
            return false
        }
        if value.regex(with: type.regex) {
            return !value.containsEmoji
        }
        return false
    }
}
