//
//  AuthManager.swift
//  AuthManager
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public protocol IAuthManager {
    var userId: String { get set }
    var userFirstName: String { get set }
    var userLastName: String { get set }
    var userEmail: String { get set }
    var userPhone: String { get set }
    var teamId: String { get set }
    var teamName: String { get set }
    var teamRole: String { get set }
    var accessToken: String { get set }
}

public class AuthManager: IAuthManager {
    public static let shared = AuthManager()
    
    public var userId: String {
        get {
            let id = KeychainService.load(service: ConstantAuth.keychain.userId, account: ConstantAuth.account) ?? ""
            return id
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.userId, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.userId, account: ConstantAuth.account, data: newValue)
            }
        }
    }
    
    public var userFirstName: String {
        get {
            let fName = KeychainService.load(service: ConstantAuth.keychain.userFirstName, account: ConstantAuth.account) ?? ""
            return fName
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.userFirstName, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.userFirstName, account: ConstantAuth.account, data: newValue)
            }
        }
    }
    
    public var userLastName: String {
        get {
            let lName = KeychainService.load(service: ConstantAuth.keychain.userLastName, account: ConstantAuth.account) ?? ""
            return lName
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.userLastName, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.userLastName, account: ConstantAuth.account, data: newValue)
            }
        }
    }
    
    public var userEmail: String {
        get {
            let email = KeychainService.load(service: ConstantAuth.keychain.userEmail, account: ConstantAuth.account) ?? ""
            return email
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.userEmail, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.userEmail, account: ConstantAuth.account, data: newValue)
            }
        }
    }
    
    public var userPhone: String {
        get {
            let phone = KeychainService.load(service: ConstantAuth.keychain.userPhone, account: ConstantAuth.account) ?? ""
            return phone
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.userPhone, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.userPhone, account: ConstantAuth.account, data: newValue)
            }
        }
    }
    
    public var teamId: String {
        get {
            let id = KeychainService.load(service: ConstantAuth.keychain.teamId, account: ConstantAuth.account) ?? ""
            return id
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.teamId, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.teamId, account: ConstantAuth.account, data: newValue)
            }
        }
    }
    
    public var teamName: String {
        get {
            let name = KeychainService.load(service: ConstantAuth.keychain.teamName, account: ConstantAuth.account) ?? ""
            return name
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.teamName, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.teamName, account: ConstantAuth.account, data: newValue)
            }
        }
    }
    
    public var teamRole: String {
        get {
            let role = KeychainService.load(service: ConstantAuth.keychain.teamRole, account: ConstantAuth.account) ?? ""
            return role
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.teamRole, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.teamRole, account: ConstantAuth.account, data: newValue)
            }
        }
    }
    
    public var accessToken: String {
        get {
            let token = KeychainService.load(service: ConstantAuth.keychain.accessToken, account: ConstantAuth.account) ?? ""
            return token
        }
        set {
            if newValue.isEmpty {
                KeychainService.remove(service: ConstantAuth.keychain.accessToken, account: ConstantAuth.account)
            } else {
                KeychainService.save(service: ConstantAuth.keychain.accessToken, account: ConstantAuth.account, data: newValue)
            }
        }
    }
}
