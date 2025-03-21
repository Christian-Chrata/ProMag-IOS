//
//  MemberDetailViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 12/05/23.
//

import Common
import Networking
import AuthManager

class MemberDetailViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .dropdown, isRequired: true, placeholder: "Roles")
    ]
    
    private var userRoleId: String = ""
    private var projectId: String = ""
    
    private var member = TeamMemberModel(userId: "", firstName: "", lastName: "", email: "", phone: "", roleId: "", roleName: "", dateJoined: "")
    
    private var selectedRoleName: String = ""
    private var roles: [RolesModel] = []
    
    init(member: TeamMemberModel = TeamMemberModel(userId: "", firstName: "", lastName: "", email: "", phone: "", roleId: "", roleName: "", dateJoined: ""), userRoleId: String, projectId: String = "") {
        self.member = member
        self.userRoleId = userRoleId
        self.projectId = projectId
        self.textFields[0].value = member.roleName
    }
    
    func getInitial() -> String {
        let initial = member.firstName
        return initial[initial.startIndex].uppercased()
    }
    func getFirstName() -> String { return member.firstName }
    func getLastName() -> String { return member.lastName }
    func getEmail() -> String { return member.email }
    func getPhone() -> String { return member.phone }
    func getAssignDate() -> String {
        let date = member.dateJoined.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")?.toString(dateFormat: "dd MMM yyyy")
        return date ?? "-"
    }
    
    func getRolesCount() -> Int { return roles.count }
    func getRolesAtRow(row: Int) -> String {
        member.roleId = roles[row].roleId
        member.roleName = roles[row].roleName
        return roles[row].roleName
    }
    
    func isHideEdit(with page: MemberDetailPage) -> Bool {
        switch page {
        case .teamDetail:
            if userRoleId == "1" || userRoleId == "2" {
                return false
            } else {
                return true
            }
        case .projectDetail:
            if userRoleId == "1" || userRoleId == "2" || userRoleId == "3" {
                return false
            } else {
                return true
            }
        case .invite:
            return false
        }
    }
    
    func getRoles(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getRoles, c: SingleResponse<getRolesResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let roles = response.data.roles
                self.roles = []
                for item in roles {
                    self.roles.append(RolesModel(roleId: "\(item.roleId)", roleName: item.roleName))
                }
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func changeRole(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        let targetId = member.userId
        let roleId = member.roleId
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.changeRole(teamId: teamId, targetId: targetId, roleId: roleId), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success:
                if targetId == CustomFunction.shared.getKeychain(with: .userId) {
                    CustomFunction.shared.setKeychain(teamRole: roleId)
                }
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func inviteMember(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        let newMemberId = member.userId
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.inviteMember(teamId: teamId, newMemberId: newMemberId), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func kickTeamMember(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        let toBeKickedId = member.userId
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.kickTeamMember(teamId: teamId, toBeKickedId: toBeKickedId), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func kickProjectMember(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let projectId = projectId
        let targetId = member.userId
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.kickProjectMember(projectId: projectId, targetId: targetId), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
