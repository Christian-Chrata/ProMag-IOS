//
//  DetailTaskViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 05/06/23.
//

import Common
import Networking
import AuthManager

class DetailTaskViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .text, isRequired: true, placeholder: "Ask a question or post an update..")
    ]
    
    private var task: TaskModel = TaskModel(projectId: "", projectName: "", id: "", userId: "", userFullname: "", title: "",  desc: "", startDate: "", endDate: "", status: "")
    
    private var subtask: [TaskModel] = []
    private var comment: [CommentModel] = []
    private var userRoleId: String = ""
    
    init(taskId: String) {
        task.id = taskId
    }
    
    func getUserRoleId() -> String { return userRoleId }
    func getTaskId() -> String { return task.id }
    func getTaskName() -> String { return task.title }
    func getTaskAssignTo() -> String { return task.userFullname }
    func getTaskDue() -> String {
        let date = task.endDate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")?.toString(dateFormat: "dd MMM yyyy")
        return date ?? "-"
    }
    func getTaskProjectName() -> String { return task.projectName }
    func getTaskDesc() -> String { return task.desc }
    func getAssignedId() -> String { return task.userId }
    func checkTaskStatus() -> Bool {
        if task.status.lowercased() == "finished" {
            return false
        }
        return true
    }
    
    func getCommentCount() -> Int { return comment.count }
    func getCommentTableHeight() -> CGFloat { return CGFloat(comment.count * 140) }
    func getCommentForRowAt(with row: Int) -> CommentModel { return comment[row] }
    
    func getSubtaskCount() -> Int { return subtask.count }
    func getSubtaskTableHeight() -> CGFloat { return CGFloat(subtask.count * 50) }
    func getSubtaskForRowAt(with row: Int) -> TaskModel { return subtask[row] }
    
    func getTaskDetail(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let taskId = task.id
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.getTaskDetail(taskId: taskId), c: SingleResponse<getTaskDetailResponse>.self) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                self.task = TaskModel(
                    projectId: data.projectData.projectId,
                    projectName: data.projectData.projectName,
                    id: data.task.taskId,
                    userId: data.task.userId,
                    userFullname: data.task.userFullname,
                    title: data.task.taskName,
                    desc: data.task.taskDesc,
                    startDate: data.task.taskStartdate,
                    endDate: data.task.taskEnddate,
                    status: data.task.status
                )
                
                let subtask = data.task.subtask
                self.subtask = []
                for item in subtask {
                    self.subtask.append(
                        TaskModel(
                            projectId: item.projectId,
                            projectName: item.projectName,
                            id: item.taskId,
                            userId: "",
                            userFullname: item.userFullname,
                            title: item.taskName,
                            desc: item.taskDesc,
                            startDate: item.taskStartdate,
                            endDate: item.taskEnddate,
                            status: item.status
                        )
                    )
                }
                
                let comment = data.task.comments
                self.comment = []
                for item in comment {
                    self.comment.append(
                        CommentModel(
                            commentId: item.commentId,
                            comment: item.comment,
                            userId: item.userId,
                            fullname: item.userFullname,
                            commentPostDate: item.commentPostdate
                        ))
                }
                
                self.userRoleId = data.userData?.roleId ?? "4"
                
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func postComment(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let taskId = task.id
        let comment = textFields[0].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.PostComment(taskId: taskId, comment: comment), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func deleteComment(with row: Int, completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let commentId = comment[row].commentId
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.DeleteComment(commentId: commentId), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func deleteTask(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let taskId = task.id
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.deleteTask(taskId: taskId), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func completeTask(completion: @escaping ((ViewState<Void>) -> Void)) {
        //Prepare data
        let taskId = task.id
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.processTask(taskId: taskId), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success:
                completion(.success(data: ()))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
