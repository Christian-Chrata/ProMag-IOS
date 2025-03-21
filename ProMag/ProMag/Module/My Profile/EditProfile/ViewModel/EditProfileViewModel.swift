//
//  EditProfileViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 27/04/23.
//

import Common
import AuthManager
import Networking

class EditProfileViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .name, isRequired: true, placeholder: "First Name"),
        UserDataModel(value: "", enabled: true, type: .name, isRequired: true, placeholder: "Last Name"),
        UserDataModel(value: "", enabled: true, type: .phone, isRequired: true, placeholder: "Phone Number (EX: +6212345)")
    ]
    
    init() {
        getUserData()
    }
    
    private func getUserData() {
        textFields[0].value = CustomFunction.shared.getKeychain(with: .userFirstName)
        textFields[1].value = CustomFunction.shared.getKeychain(with: .userLastName)
        textFields[2].value = CustomFunction.shared.getKeychain(with: .userPhone)
    }
    
    func checkUser() -> Bool {
        let old = [
            CustomFunction.shared.getKeychain(with: .userFirstName),
            CustomFunction.shared.getKeychain(with: .userLastName),
            CustomFunction.shared.getKeychain(with: .userPhone)
        ]
        
        let new = [
            textFields[0].value,
            textFields[1].value,
            textFields[2].value
        ]
        
        for i in 0...old.count - 1 {
            if old[i] != new[i] {
                return true
            }
        }
        return false
    }
    
    
    func saveUser(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let id = CustomFunction.shared.getKeychain(with: .userId)
        let name = "\(textFields[0].value) \(textFields[1].value)"
        let phone = textFields[2].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.editUserInfo(id: id, username: name, phone: phone), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                CustomFunction.shared.setKeychain(name: name, phone: phone)
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
