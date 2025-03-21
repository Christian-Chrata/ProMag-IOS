//
//  TeamInviteViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 13/05/23.
//

import Common
import Networking
import AuthManager

class TeamInviteViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .email, isRequired: true, placeholder: "Email (EX: user@mail.com)")
    ]
    
    private var target: [TeamInviteModel] = []
    
    func getTargetForRow(row: Int) -> TeamMemberModel {
        let data = target[row]
        let member: TeamMemberModel = TeamMemberModel(
            userId: data.userId,
            firstName: data.userFirstName,
            lastName: data.userLastName,
            email: data.userEmail,
            phone: data.userPhone,
            roleId: "",
            roleName: "",
            dateJoined: ""
        )
        return member
    }
    
    func getTargetCount() -> Int { return target.count }
    
    func getUserRole() -> String { return CustomFunction.shared.getKeychain(with: .teamRole) }
    
    func searchUser(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        let query = textFields[0].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.searchMember(teamId: teamId, query: query), c: SingleResponse<searchMemberResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let targetUser = response.data.users
                self.target = []
                for item in targetUser {
                    
                    var components = item.userFullname.components(separatedBy: " ")
                    if components.count > 0 {
                        let firstName = components.removeFirst()
                        let lastName = components.joined(separator: " ")
                        
                        self.target.append(TeamInviteModel(
                            userId: "\(item.userId)",
                            userFirstName: firstName,
                            userLastName: lastName,
                            userEmail: item.userEmail,
                            userPhone: item.userPhone
                        ))
                    }
                    
                }
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
