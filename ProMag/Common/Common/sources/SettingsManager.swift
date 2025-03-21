//
//  SettingsManager.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

@propertyWrapper
public struct UserDefaultsBacked<Value> {
    public var wrappedValue: Value {
        get {
            let value = storage.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }

    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults

    init(wrappedValue defaultValue: Value,
         key: String,
         storage: UserDefaults = .standard) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults = .standard) {
        self.init(wrappedValue: nil, key: key, storage: storage)
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

extension UserDefaults {
    static var shared: UserDefaults {
        let combined = UserDefaults.standard
        combined.addSuite(named: "com.chrata.Common")
        return combined
    }
}

public struct SettingsManager {
    @UserDefaultsBacked(key: "isFirstOpen", storage: .shared)
    public static var isFirstOpen: Bool?
    @UserDefaultsBacked(key: "version", storage: .shared)
    public static var version: Bool?
    @UserDefaultsBacked(key: "device", storage: .shared)
    public static var device: Bool?
    @UserDefaultsBacked(key: "OS", storage: .shared)
    public static var OS: Bool?
    @UserDefaultsBacked(key: "cif_key", storage: .shared)
    public static var cif: String?
    @UserDefaultsBacked(key: "api_key", storage: .shared)
    public static var api: String?
    @UserDefaultsBacked(key: "name", storage: .shared)
    public static var name: String?
    @UserDefaultsBacked(key: "fullName", storage: .shared)
    public static var fullName: String?
    @UserDefaultsBacked(key: "email", storage: .shared)
    public static var email: String?
    @UserDefaultsBacked(key: "tkdn", storage: .shared)
    public static var tkdn: String?
    @UserDefaultsBacked(key: "tokenlogin", storage: .shared)
    public static var tokenlogin: String?
    @UserDefaultsBacked(key: "rated", storage: .shared)
    public static var rated: Bool?
}
