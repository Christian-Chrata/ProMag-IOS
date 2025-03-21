//
//  LoginViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 08/01/23.
//

import Common
import Networking
import AuthManager

class LoginViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .email, isRequired: true, placeholder: "Email (EX: user@mail.com)"),
        UserDataModel(value: "", enabled: true, type: .loginPass, isRequired: true, placeholder: "Password")
    ]
    
    func login(completion: @escaping ((ViewState<Void>) -> Void)) {
        // Prepare data
        let email = textFields[0].value
        let password = textFields[1].value
        
        // Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.login(email: email, password: password), c: SingleResponse<LoginResponse>.self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                if response.data.userTeamId?.count != 0 {
                    guard let id = response.data.userInfo?.userId,
                          let name = response.data.userInfo?.userFullname,
                          let email = response.data.userInfo?.userEmail,
                          let phone = response.data.userInfo?.userPhone,
                          let accessToken = response.data.accessToken,
                          let teamId = response.data.userTeamId?[0].teamId,
                          let teamName = response.data.userTeamId?[0].teamName,
                          let teamRole = response.data.userTeamId?[0].roleId
                    else { return }
                    
                    // Save data
                    CustomFunction.shared.setKeychain(
                        id: "\(id)",
                        name: name,
                        email: email,
                        phone: phone,
                        teamId: teamId,
                        teamName: teamName,
                        teamRole: teamRole,
                        access: accessToken
                    )
                } else {
                    guard let id = response.data.userInfo?.userId,
                          let name = response.data.userInfo?.userFullname,
                          let email = response.data.userInfo?.userEmail,
                          let phone = response.data.userInfo?.userPhone,
                          let accessToken = response.data.accessToken
                    else { return }
                            
                    // Save data
                    CustomFunction.shared.setKeychain(id: "\(id)",
                                                      name: name,
                                                      email: email,
                                                      phone: phone,
                                                      access: accessToken
                    )
                }
                
                
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
