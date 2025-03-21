//
//  CreateTeamViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/04/23.
//

import Common
import AuthManager
import Networking

class ProfileTeamViewModel {
    
    private var id: String = ""
    private var isFirst = true
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .text, isRequired: true, placeholder: "Team Name"),
        UserDataModel(value: "", enabled: true, type: .text, isRequired: true, placeholder: "Team Description")
    ]
    
    func getTeamData(id: String, name: String, description: String) {
        self.id = id
        textFields[0].value = name
        textFields[1].value = description
    }
    
    func getTeamId() -> String { return id }
    
    func getTeamName() -> String { return textFields[0].value }
    
    func getTeamDesc() -> String { return textFields[1].value }
    
    func isEditFirstTime() -> Bool {
        if isFirst {
            isFirst = false
            return false
        }
        return true
    }
    
    func createTeam(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let name = textFields[0].value
        let description = textFields[1].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.createTeam(name: name, description: description), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func updateTeam(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let id = id
        let name = textFields[0].value
        let description = textFields[1].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.editTeam(id: id, name: name, description: description), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func deleteTeam(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let teamId = self.id
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.leaveTeam(teamId: id), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                if teamId == CustomFunction.shared.getKeychain(with: .teamId) {
                    CustomFunction.shared.setKeychain(
                        teamId: "",
                        teamName:  "",
                        teamRole: ""
                    )
                }
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
