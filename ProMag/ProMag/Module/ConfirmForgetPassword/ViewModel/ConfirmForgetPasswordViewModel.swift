//
//  ConfirmForgetPasswordViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 14/04/23.
//

import Common
import Networking

class ConfrmForgetPasswordViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .pass, isRequired: true, placeholder: "New Password"),
        UserDataModel(value: "", enabled: true, type: .pass, isRequired: true, placeholder: "Confirm New Password")
    ]
    
    var email = ""
    var token = ""
    
    init (email: String, token: String) {
        self.email = email
        self.token = token
    }
    
    func resetPassword(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let userEmail = email
        let token =  token
        let password = textFields[0].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.resetPassword(userEmail: userEmail, token: token, password: password), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
