//
//  ChangePasswordViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 02/05/23.
//

import Common
import Networking
import AuthManager

class ChangePasswordViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .loginPass, isRequired: true, placeholder: "Current Password"),
        UserDataModel(value: "", enabled: true, type: .pass, isRequired: true, placeholder: "New Password"),
        UserDataModel(value: "", enabled: true, type: .pass, isRequired: true, placeholder: "Confirm New Password")
    ]
    
    func changePassword(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let id = CustomFunction.shared.getKeychain(with: .userId)
        let currentPass = textFields[0].value
        let newPass = textFields[1].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.changePassword(id: id, oldPassword: currentPass, newPassword: newPass), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
