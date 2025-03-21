//
//  MyProfileViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 18/04/23.
//

import Common
import Networking
import AuthManager

class MyProfileViewModel {
    
    private var teams: [TeamListModel] = []
    
    func getUserData(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let id = CustomFunction.shared.getKeychain(with: .userId)
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getUserProfile(id: id), c: SingleResponse<GetUserProfileResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                CustomFunction.shared.setKeychain(
                    id: "\(data.userId)",
                    name: data.userFullname,
                    email: data.userEmail,
                    phone: data.userPhone
                )
                
                self.teams = []
                let teams = response.data.userTeams
                for team in teams {
                    if team.teamId == CustomFunction.shared.getKeychain(with: .teamId) {
                        CustomFunction.shared.setKeychain(teamName: team.teamName, teamRole: team.roleId)
                        self.teams.append(TeamListModel(id: team.teamId, name: team.teamName, desc: team.teamDesc, type: .active))
                    } else {
                        self.teams.append(TeamListModel(id: team.teamId, name: team.teamName, desc: team.teamDesc, type: .deactive)) 
                    }
                }
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func getCurrentTeam() -> String { return CustomFunction.shared.getKeychain(with: .teamName) }
    
    func getUserFirstLetter() -> String {
        let firstName = CustomFunction.shared.getKeychain(with: .userFirstName)
        return "\(firstName[firstName.startIndex].uppercased())"
    }
    
    func getUserName() -> String {
        return "\(CustomFunction.shared.getKeychain(with: .userFirstName)) \(CustomFunction.shared.getKeychain(with: .userLastName))"
    }
    
    func getUserEmail() -> String { return CustomFunction.shared.getKeychain(with: .userEmail) }
    
    func getTeamForRowAt(row: Int) -> TeamListModel { return teams[row] }
    
    func getTeamCount() -> Int { return teams.count }
    
    func getTableViewHeight() -> CGFloat { return CGFloat(teams.count * 58) }
    
    func checkSelectedTeam(with row: Int) -> Bool {
        if teams[row].type == .active {
            return false
        } else {
            return true
        }
    }
    
    func selectTeam(with row: Int) {
        let id = teams[row].id
        let name = teams[row].name
        CustomFunction.shared.setKeychain(teamId: id, teamName: name)
    }
}
