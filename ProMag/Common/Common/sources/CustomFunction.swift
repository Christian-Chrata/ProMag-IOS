//
//  GlobalFunciton.swift
//  Common
//
//  Created by Christian Wiradinata on 08/01/23.
//

import UIKit
import AuthManager

public enum AuthKeyType {
    case userId
    case userFirstName
    case userLastName
    case userEmail
    case userPhone
    case accessToken
    case teamId
    case teamName
    case teamRole
}

public class CustomFunction {
    
    private init () {}
    
    private var scrollView: UIScrollView?
    private var errors: [String] = []
    
    public static let shared: CustomFunction = CustomFunction()
    
    public func setKeyboard(with scrollView: UIScrollView) {
        self.scrollView = scrollView
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let scrollView = scrollView else { return }
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        var contentInsets = scrollView.contentInset
        contentInsets.bottom = keyboardSize.height
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        guard let scrollView = scrollView else { return }
        var contentInsets = scrollView.contentInset
        contentInsets.bottom = 0
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    public func validate(with data: [UserDataModel]) -> Bool {
        errors = []
        return data.enumerated().reduce(true) { (r, t) -> Bool in
            if t.element.isRequired && !t.element.isValid() {
                errors.append("- \(t.element.placeholder)")
            }
            return r && t.element.isValid()
        }
    }
    
    public func getError() -> String {
        return "Please check your data:<br> \(errors.joined(separator: "<br>"))"
    }
    
    public func setKeychain(
        id: String = AuthManager.shared.userId,
        name: String = "\(AuthManager.shared.userFirstName) \(AuthManager.shared.userLastName)",
        email: String = AuthManager.shared.userEmail,
        phone: String = AuthManager.shared.userPhone,
        teamId: String = AuthManager.shared.teamId,
        teamName: String = AuthManager.shared.teamName,
        teamRole: String = AuthManager.shared.teamRole,
        access: String = AuthManager.shared.accessToken
    ) {
        if id != AuthManager.shared.userId {
            AuthManager.shared.userId = ""
            AuthManager.shared.userId = id
        }
        
        var components = name.components(separatedBy: " ")
        if components.count > 0 {
            let firstName = components.removeFirst()
            let lastName = components.joined(separator: " ")
            
            if firstName != AuthManager.shared.userFirstName {
                AuthManager.shared.userFirstName = ""
                AuthManager.shared.userFirstName = firstName
            }
            
            if lastName != AuthManager.shared.userLastName {
                AuthManager.shared.userLastName = ""
                AuthManager.shared.userLastName = lastName
            }
        }
        
        if email != AuthManager.shared.userEmail {
            AuthManager.shared.userEmail = ""
            AuthManager.shared.userEmail = email
        }
        
        if phone != AuthManager.shared.userPhone {
            AuthManager.shared.userPhone = ""
            AuthManager.shared.userPhone = phone
        }
        
        if teamId != AuthManager.shared.teamId {
            AuthManager.shared.teamId = ""
            AuthManager.shared.teamId = teamId
        }
        
        if teamName != AuthManager.shared.teamName {
            AuthManager.shared.teamName = ""
            AuthManager.shared.teamName = teamName
        }
        
        if teamRole != AuthManager.shared.teamRole {
            AuthManager.shared.teamRole = ""
            AuthManager.shared.teamRole = teamRole
        }
        
        if access != AuthManager.shared.accessToken {
            AuthManager.shared.accessToken = ""
            AuthManager.shared.accessToken = access
        }
    }
    
    public func removeKeychain() {
        AuthManager.shared.userId = ""
        AuthManager.shared.userFirstName = ""
        AuthManager.shared.userLastName = ""
        AuthManager.shared.userEmail = ""
        AuthManager.shared.userPhone = ""
        AuthManager.shared.teamId = ""
        AuthManager.shared.teamName = ""
        AuthManager.shared.teamRole = ""
        AuthManager.shared.accessToken = ""
    }
    
    public func getKeychain(with key: AuthKeyType) -> String {
        switch key {
        case .userId:
            return AuthManager.shared.userId
        case .userFirstName:
            return AuthManager.shared.userFirstName
        case .userLastName:
            return AuthManager.shared.userLastName
        case .userEmail:
            return AuthManager.shared.userEmail
        case .userPhone:
            return AuthManager.shared.userPhone
        case .teamId:
            return AuthManager.shared.teamId
        case .teamName:
            return AuthManager.shared.teamName
        case .teamRole:
            return AuthManager.shared.teamRole
        case .accessToken:
            return AuthManager.shared.accessToken
        }
    }
}
