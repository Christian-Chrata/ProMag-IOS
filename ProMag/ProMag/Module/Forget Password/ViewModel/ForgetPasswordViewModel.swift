//
//  ForgetPasswordViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 29/01/23.
//

import Common
import Networking

class ForgetPasswordViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .email, isRequired: true, placeholder: "Email (EX: user@mail.com)"),
    ]
    
    func forgetPassword(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let email = textFields[0].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.forgetPassword(email: email), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success:
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
