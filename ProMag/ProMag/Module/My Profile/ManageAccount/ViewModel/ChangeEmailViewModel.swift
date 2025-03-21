//
//  ChangeEmailViewModle.swift
//  ProMag
//
//  Created by Christian Wiradinata on 02/05/23.
//

import Common
import Networking
import AuthManager

class ChangeEmailViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "\(CustomFunction.shared.getKeychain(with: .userEmail))", enabled: false, type: .email, isRequired: true, placeholder: "Current Email (EX: user@mail.com)"),
        UserDataModel(value: "", enabled: true, type: .email, isRequired: true, placeholder: "New Email (EX: user@mail.com)")
    ]
    
    func getEmail() -> String { return textFields[1].value }
    
    func verifyEmail(otp: String, completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let id = CustomFunction.shared.getKeychain(with: .userId)
        let email = textFields[1].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.verifyUserEmail(id: id, email: email, otp: otp), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                CustomFunction.shared.setKeychain(email: email)
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func changeEmail(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let id = CustomFunction.shared.getKeychain(with: .userId)
        let email = textFields[1].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.editUserEmail(id: id, newEmail: email), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
