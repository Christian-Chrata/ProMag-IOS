//
//  MyTeamViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 05/05/23.
//

import Common
import AuthManager
import Networking

class MyTeamViewModel {
    
    private var project: [ProjectModel] = []
    
    func getTeamInfo(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        
        //Hit API
        if teamId != "" {
            completion(.loading)
            NetworkManager.instance.requestObject(ServiceAPI.getTeamInfo(teamId: teamId), c: SingleResponse<getTeamInfoResponse>.self) { (result) in
                switch result {
                case .success(let response):
                    CustomFunction.shared.setKeychain(
                        teamId: response.data.teamId,
                        teamName: response.data.teamName,
                        teamRole: response.data.roleId
                    )
                    completion(.success(data: ()))
                case .failure(let error):
                    completion(.error(error: error))
                }
            }
        } else {
            completion(.success(data: ()))
        }
    }
    
    func getProjectData(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        
        //Hit API
        if teamId != "" {
            completion(.loading)
            NetworkManager.instance.requestObject(ServiceAPI.getProject(teamId: teamId), c: SingleResponse<getProjectResponse>.self) { (result) in
                switch result {
                case .success(let response):
                    let projects = response.data.projects
                    self.project = []
                    for item in projects {
                        let start = item.projectStartdate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")?.toString(dateFormat: "dd MMMM YYYY")
                        let end = item.projectEnddate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")?.toString(dateFormat: "dd MMMM YYYY")
                        self.project.append(ProjectModel(
                            projectId: "\(item.projectId)",
                            teamId: item.teamId,
                            pmName: item.projectManager,
                            projectName: item.projectName,
                            projectDesc: item.projectDesc,
                            status: item.status,
                            projectStartdate: "\(start ?? "-")",
                            projectEnddate: "\(end ?? "-")"
                        ))
                    }
                    completion(.success(data: ()))
                case .failure(let error):
                    completion(.error(error: error))
                }
            }
        } else {
            project = []
            completion(.success(data: ()))
        }
    }
    
    func isHideAddProject() -> Bool {
        let roleId = CustomFunction.shared.getKeychain(with: .teamRole)
        if roleId == "1" || roleId == "2" {
            return false
        } else {
            return true
        }
    }
    
    func getRoleId() -> String { return CustomFunction.shared.getKeychain(with: .teamRole) }
    
    func getCurrentTeam() -> String { return CustomFunction.shared.getKeychain(with: .teamName) }
    
    func isShowMember() -> Bool {
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        if teamId != "" {
            return true
        }
        return false
    }
    
    func getProjectForRowAt(row: Int) -> ProjectModel { return project[row] }
    
    func getProjectCount() -> Int { return project.count }
    
}
