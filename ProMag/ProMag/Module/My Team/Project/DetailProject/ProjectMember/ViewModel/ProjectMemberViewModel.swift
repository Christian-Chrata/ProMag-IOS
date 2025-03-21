//
//  ProjectMemberViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/05/23.
//

import Foundation
import Networking
import Common

class ProjectMemberViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .text, isRequired: false, placeholder: "Search Member")
    ]
    
    private var projectId: String = ""
    private var projectRoleId: String = ""
    
    private var members: [TeamMemberModel] = []
    private var searchMembers: [TeamMemberModel] = []
    
    init(projectId: String = "") {
        self.projectId = projectId
    }
    
    func getMembersCount() -> Int { return searchMembers.count }
    func getMemberForRowAt(with row: Int) -> TeamMemberModel { return searchMembers[row] }
    func getProjectId() -> String { return projectId }
    
    func getUserRole() -> String { return projectRoleId }
    
    func getMemberData(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let projectId = projectId
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getProjectInfo(projectId: projectId), c: SingleResponse<getProjectInfoResponse>.self) { (result) in
            switch result {
            case .success(let response):

                let data = response.data.members

                self.members = []
                
                var tempMembers: [TeamMemberModel] = []
                
                for member in data {
                    var components = member.userFullname.components(separatedBy: " ")
                    if components.count > 0 {
                        let firstName = components.removeFirst()
                        let lastName = components.joined(separator: " ")
                        
                        tempMembers.append(TeamMemberModel(
                            userId: member.userId,
                            firstName: firstName,
                            lastName: lastName,
                            email: member.userEmail,
                            phone: member.userPhone,
                            roleId: member.roleId,
                            roleName: member.roleName,
                            dateJoined: member.assignDate
                        ))
                    }
                    
                    if member.userId == CustomFunction.shared.getKeychain(with: .userId) {
                        self.projectRoleId = member.roleId
                    }
                }
                
                self.members = tempMembers.sorted(by: { $0.roleId < $1.roleId })
                self.searchMembers = self.members
                
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func searchMember(with text: String) {
        if text != "" {
            self.searchMembers = self.members.filter { item in
                let combinedText = "\(item.firstName) \(item.lastName) \(item.email) \(item.phone)"
                return combinedText.lowercased().contains(text.lowercased())
            }
        } else {
            self.searchMembers = self.members
        }
    }
    
    func isAllowedToInvite() -> Bool {
        let roleId = projectRoleId
        if roleId == "3" {
            return true
        } else {
            return false
        }
    }
}
