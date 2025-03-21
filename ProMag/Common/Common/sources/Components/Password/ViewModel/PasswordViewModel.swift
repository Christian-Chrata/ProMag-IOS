//
//  PasswordViewModel.swift
//  Common
//
//  Created by Christian Wiradinata on 03/05/23.
//

import Networking

public class PasswordViewModel{
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .loginPass, isRequired: true, placeholder: "Password")
    ]
    
    func getPassword() -> String { return textFields[0].value }
}
