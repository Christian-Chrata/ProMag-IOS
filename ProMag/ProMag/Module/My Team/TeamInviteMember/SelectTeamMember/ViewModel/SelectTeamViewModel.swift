//
//  SelectTeamViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 20/05/23.
//

import UIKit
import Common
import Networking
import AuthManager

class SelectTeamViewModel {
    
    private var teams: [TeamMemberModel] = []
    private var projectId: String = ""
    
    init(projectId: String = "") {
        self.projectId = projectId
    }
    
    func getTeamForRow(row: Int) -> TeamMemberModel { return teams[row] }
    func getTeamsCount() -> Int { return teams.count }
    func getTeamIsJoin(with row: Int) -> Bool { return teams[row].isJoined}
    
    func selectMultipleMember(with row: Int) {
        teams[row].isChecked = !teams[row].isChecked
    }
    
    func getTeamsData(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let id = CustomFunction.shared.getKeychain(with: .teamId)
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getTeamMember(teamId: id), c: SingleResponse<GetTeamMemberResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let data = response.data.teamMembers

                self.teams = []
                for team in data {
                    
                    var components = team.userFullname.components(separatedBy: " ")
                    if components.count > 0 {
                        let firstName = components.removeFirst()
                        let lastName = components.joined(separator: " ")
                        
                        self.teams.append(
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
                    }
                    
                }
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func getMultipleProjectTeamData(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let projectId = self.projectId
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getProjectMember(projectId: projectId), c: SingleResponse<getProjectMemberResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let data = response.data.members

                self.teams = []
                for team in data {
                    var components = team.userFullname.components(separatedBy: " ")
                    if components.count > 0 {
                        let firstName = components.removeFirst()
                        let lastName = components.joined(separator: " ")
                        var isChecked = false
                        if team.alreadyExist == "1" {
                            isChecked = true
                        }
                        
                        self.teams.append(
                            TeamMemberModel(
                                userId: team.userId,
                                firstName: firstName,
                                lastName: lastName,
                                email: "",
                                phone: "",
                                roleId: "",
                                roleName: "",
                                dateJoined: "",
                                isChecked: isChecked,
                                isJoined: isChecked
                            )
                        )
                    }
                }
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func insertUser(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let projectId = self.projectId
        var targetId: String = ""
        
        for member in teams {
            if member.isChecked != member.isJoined {
                if targetId == "" {
                    targetId += "\(member.userId)"
                } else {
                    targetId += ",\(member.userId)"
                }
            }
        }
        
        
        //Hit API
        if targetId != "" {
            completion(.loading)
            NetworkManager.instance.requestObject(ServiceAPI.insertUser(projectId: projectId, targetId: targetId), c: SingleResponse<EmptyData>.self) { (result) in
                switch result {
                case .success(let response):
                    completion(.success(data: response.message))
                case .failure(let error):
                    completion(.error(error: error))
                }
            }
        } else {
            completion(.success(data: ""))
        }
    }
}
