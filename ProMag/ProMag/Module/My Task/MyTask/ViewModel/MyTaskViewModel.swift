//
//  MyTaskViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/05/23.
//

import Common
import AuthManager
import Networking

class MyTaskViewModel {
    
    private var tasks: [TaskModel] = []
    private var state: TaskSortingState = .alphabet
    
    func getTaskData(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        
        //Hit API
        if teamId != "" {
            completion(.loading)
            NetworkManager.instance.requestObject(ServiceAPI.getMyTasks(teamId: teamId), c: SingleResponse<getTasksResponse>.self) { (result) in
                switch result {
                case .success(let response):

                    let data = response.data.tasks

                    self.tasks = []
                    
                    var tempTasks: [TaskModel] = []
                    
                    for task in data {
                        tempTasks.append(
                            TaskModel(
                                projectId: task.projectId,
                                projectName: task.projectName,
                                id: task.taskId,
                                userId: "",
                                userFullname: task.userFullname ?? "",
                                title: task.taskName,
                                desc: task.taskDesc,
                                startDate: task.taskStartdate,
                                endDate: task.taskEnddate,
                                status: task.status
                            ))
                    }
                    
                    self.state = .alphabet
                    self.tasks = tempTasks.sorted(by: { $0.title < $1.title })
                    
                    completion(.success(data: ()))
                case .failure(let error):
                    completion(.error(error: error))
                }
            }
        } else {
            tasks = []
            completion(.success(data: ()))
        }
    }
    
    func getCurrentTeam() -> String { return CustomFunction.shared.getKeychain(with: .teamName) }
    
    func getTaskForRowAt(with row: Int) -> TaskModel { return tasks[row] }
    
    func getTaskCount() -> Int { return tasks.count }
    
    func getTaskState() -> TaskSortingState { return state }
    
    func sortingTask(with state: TaskSortingState) {
        let tempTasks = tasks
        
        switch state {
        case .alphabet:
            // sort to date
            self.tasks = tempTasks.sorted(by: { $0.endDate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? Date() < $1.endDate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? Date() })
            self.state = .date
        case .date:
            // sort to alphabet
            self.tasks = tempTasks.sorted(by: { $0.title < $1.title })
            self.state = .alphabet
        }
    }
    
}
