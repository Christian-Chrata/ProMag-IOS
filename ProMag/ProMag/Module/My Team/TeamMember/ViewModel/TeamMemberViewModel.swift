//
//  TeamMemberViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 11/05/23.
//

import UIKit
import Common
import Networking
import AuthManager

class TeamMemberViewModel {
    
    private var teams: [TeamMemberModel] = []
    
    func getTeamForRow(row: Int) -> TeamMemberModel { return teams[row] }
    func getTeamsCount() -> Int { return teams.count }
    
    func isHideInvite() -> Bool {
        let roleId = CustomFunction.shared.getKeychain(with: .teamRole)
        if roleId == "1" || roleId == "2" {
            return false
        } else {
            return true
        }
    }
    
    func getUserRole() -> String { return CustomFunction.shared.getKeychain(with: .teamRole) }
    
    func getTeamsData(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let id = CustomFunction.shared.getKeychain(with: .teamId)
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getTeamMember(teamId: id), c: SingleResponse<GetTeamMemberResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let data = response.data.teamMembers
                
                var tempTeams: [TeamMemberModel] = []

                self.teams = []
                for team in data {
                    
                    var components = team.userFullname.components(separatedBy: " ")
                    if components.count > 0 {
                        let firstName = components.removeFirst()
                        let lastName = components.joined(separator: " ")
                        
                        tempTeams.append(
                            TeamMemberModel(
                                userId: team.userId,
                                firstName: firstName,
                                lastName: lastName,
                                email: team.userEmail,
                                phone: team.userPhone,
                                roleId: team.roleId,
                                roleName: team.roleName,
                                dateJoined: team.dateJoined)
                        )
                        
                        self.teams = tempTeams.sorted(by: { $0.roleId < $1.roleId })
                    }
                    
                }
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
