//
//  KeychainService.swift
//  AuthManager
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation
import Security

// see https://stackoverflow.com/a/37539998/1694526
// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

class KeychainService: NSObject {
    
    class func update(service: String, account: String, data: String) {
        if let dataFromString: Data = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
            
            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
            
            printResultCode(resultCode: status)
        }
    }
    
    
    class func remove(service: String, account: String) {
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
        
        // Delete any existing items
        let status = SecItemDelete(keychainQuery as CFDictionary)
        
        printResultCode(resultCode: status)
    }
    
    
    class func save(service: String, account: String, data: String) {
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            // Add the new keychain item
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            
            printResultCode(resultCode: status)
        }
    }
    
    class func load(service: String, account: String) -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue!, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
    
    class func printResultCode(resultCode: OSStatus) {
        // See: https://www.osstatus.com/
        switch resultCode {
        case errSecSuccess:
            print("Keychain Status: No error.")
        case errSecUnimplemented:
            print("Keychain Status: Function or operation not implemented.")
        case errSecIO:
            print("Keychain Status: I/O error (bummers)")
        case errSecOpWr:
            print("Keychain Status: File already open with with write permission")
        case errSecParam:
            print("Keychain Status: One or more parameters passed to a function where not valid.")
        case errSecAllocate:
            print("Keychain Status: Failed to allocate memory.")
        case errSecUserCanceled:
            print("Keychain Status: User canceled the operation.")
        case errSecBadReq:
            print("Keychain Status: Bad parameter or invalid state for operation.")
        case errSecInternalComponent:
            print("Keychain Status: Internal Component")
        case errSecNotAvailable:
            print("Keychain Status: No keychain is available. You may need to restart your computer.")
        case errSecDuplicateItem:
            print("Keychain Status: The specified item already exists in the keychain.")
        case errSecItemNotFound:
            print("Keychain Status: The specified item could not be found in the keychain.")
        case errSecInteractionNotAllowed:
            print("Keychain Status: User interaction is not allowed.")
        case errSecDecode:
            print("Keychain Status: Unable to decode the provided data.")
        case errSecAuthFailed:
            print("Keychain Status: The user name or passphrase you entered is not correct.")
        default:
            print("Keychain Status: Unknown. (\(resultCode))")
        }
    }
    
}
