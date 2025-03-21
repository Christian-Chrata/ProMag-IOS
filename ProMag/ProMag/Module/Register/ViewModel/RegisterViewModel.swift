//
//  RegisterViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 05/01/23.
//

import Common
import Networking

class RegisterViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .name, isRequired: true, placeholder: "First Name"),
        UserDataModel(value: "", enabled: true, type: .name, isRequired: true, placeholder: "Last Name"),
        UserDataModel(value: "", enabled: true, type: .phone, isRequired: true, placeholder: "Phone Number (EX: +6212345)"),
        UserDataModel(value: "", enabled: true, type: .email, isRequired: true, placeholder: "Email (EX: user@mail.com)"),
        UserDataModel(value: "", enabled: true, type: .pass, isRequired: true, placeholder: "Password"),
        UserDataModel(value: "", enabled: true, type: .pass, isRequired: true, placeholder: "Confirm Password")
    ]
    
    func getEmail() -> String {
        return textFields[3].value
    }
    
    func register(completion: @escaping ((ViewState<Void>) -> Void)) {
        // Prepare data
        let name = "\(textFields[0].value) \(textFields[1].value)"
        let phone = textFields[2].value
        let email = textFields[3].value
        let password = textFields[4].value
        
        // Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.register(name: name, phone: phone, email: email, password: password), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success:
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func getOTP(completion: @escaping ((ViewState<Void>) -> Void)) {
        // Prepare data
        let email = textFields[3].value
        
        // Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getOTP(email: email), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success:
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func verifyOtp(otp: String, completion: @escaping ((ViewState<String>) -> Void)) {
        // Prepare data
        let email = textFields[3].value

        // Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.verifyOtp(email: email, otp: otp), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: (response.message)))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
