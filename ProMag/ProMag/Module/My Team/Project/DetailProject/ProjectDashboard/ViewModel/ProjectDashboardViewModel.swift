//
//  ProjectDashboardViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/05/23.
//

import Foundation
import Common
import Networking

class ProjectDashboardViewModel {
    
    private var dashboard: DashboardModel = DashboardModel(completedTask: 0, totalTask: 0, percentage: 0, totalMember: 0)
    
    private var projectId: String = ""
    
    init(projectId: String = "") {
        self.projectId = projectId
    }
    
    func getTaskCompleted() -> String { return "\(dashboard.completedTask)" }
    func getPercentage() -> String { return "\(dashboard.percentage)" }
    func getTotalTasks() -> String { return "\(dashboard.totalTask)" }
    func getTotalMember() -> String { return "\(dashboard.totalMember)" }
    
    func getDashboardData(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let projectId = projectId
        
        //Hit API
        completion(.loading)
        
        NetworkManager.instance.requestObject(ServiceAPI.getProjectDashboard(projectId: projectId), c: SingleResponse<getDashboardResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                self.dashboard = DashboardModel(
                    completedTask: data.completedTask,
                    totalTask: data.totalTask,
                    percentage: data.percentage,
                    totalMember: data.totalMember
                )
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
