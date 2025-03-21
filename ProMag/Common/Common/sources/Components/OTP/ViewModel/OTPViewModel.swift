//
//  OTPViewModel.swift
//  Common
//
//  Created by Christian Wiradinata on 16/04/23.
//

import Networking

public class OTPViewModel {
    
    private var email: String = ""
    
    public init(with email: String = "") {
        self.email = email
    }
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .number, isRequired: true, placeholder: "Code")
    ]
    
    func getEmail() -> String { return email }
    
    func getOTP() -> String { return textFields[0].value }
}
