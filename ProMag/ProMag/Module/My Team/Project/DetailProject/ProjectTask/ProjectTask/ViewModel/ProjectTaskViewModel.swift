//
//  ProjectTaskViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 27/05/23.
//

import Foundation
import Networking
import Common

class ProjectTaskViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .text, isRequired: false, placeholder: "Search Task")
    ]
    
    private var tasks: [TaskModel] = []
    private var searchTasks: [TaskModel] = []
    
    private var projectId: String = ""
    private var projectRoleId: String = ""
    private var state: TaskSortingState = .alphabet
    
    init(projectId: String = "") {
        self.projectId = projectId
    }
    
    func getTaskCount() -> Int { return searchTasks.count }
    func getTaskForRowAt(with row: Int) -> TaskModel { return searchTasks[row] }
    func getProjectId() -> String { return projectId }
    
    func getUserRole() -> String { return projectRoleId }
    
    func getTask(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let projectId = projectId
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getTasks(projectId: projectId), c: SingleResponse<getProjectTasksResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let projectData = response.data.projectData
                
                self.projectRoleId = response.data.userData.roleId
                
                let data = response.data.tasks

                self.tasks = []
                
                var tempTasks: [TaskModel] = []
                
                for task in data {
                    tempTasks.append(
                        TaskModel(
                            projectId: projectData.projectId,
                            projectName: projectData.projectName,
                            id: task.taskId,
                            userId: "",
                            userFullname: task.userFullname,
                            title: task.taskName,
                            desc: task.taskDesc,
                            startDate: task.taskStartdate,
                            endDate: task.taskEnddate,
                            status: task.status
                        ))
                }
                
                self.tasks = tempTasks.sorted(by: { $0.title < $1.title })
                self.searchTasks = self.tasks
                
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func searchTask(with text: String) {
        if text != "" {
            self.searchTasks = self.tasks.filter { task in
                let combinedText = "\(task.title) \(task.desc) \(task.userFullname)"
                return combinedText.lowercased().contains(text.lowercased())
            }
        } else {
            self.searchTasks = self.tasks
        }
    }
    
    func getTaskState() -> TaskSortingState { return state }
    
    func sortingTask(with state: TaskSortingState) {
        let tempTasks = searchTasks
        switch state {
        case .alphabet:
            // sort to date
            self.searchTasks = tempTasks.sorted(by: { $0.endDate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? Date() < $1.endDate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? Date() })
            self.state = .date
        case .date:
            // sort to alphabet
            self.searchTasks = tempTasks.sorted(by: { $0.title < $1.title })
            self.state = .alphabet
        }
    }
    
    func isAllowedToAdd() -> Bool {
        let roleId = projectRoleId
        if roleId == "3" || roleId == "4" {
            return true
        } else {
            return false
        }
    }
}
