//
//  ManageAccountViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 30/04/23.
//

import Common
import AuthManager
import Networking

class ManageAccountViewModel {
    
    func getEmail() -> String { return CustomFunction.shared.getKeychain(with: .userEmail) }
    
    func deleteAccount(password: String, completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let id = CustomFunction.shared.getKeychain(with: .userId)
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.deleteAccount(id: id, password: password), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                CustomFunction.shared.removeKeychain()
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
