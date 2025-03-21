//
//  CreateSubtaskViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 08/06/23.
//

import Common
import Networking
import AuthManager

class CreateSubtaskViewModel {
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .text, isRequired: true, placeholder: "Task Name"),
        UserDataModel(value: "", enabled: true, type: .text, isRequired: true, placeholder: "Description"),
        UserDataModel(value: "", enabled: true, type: .dropdown, isRequired: true, placeholder: "Assign to"),
        UserDataModel(value: "", enabled: true, type: .text, isRequired: false, placeholder: "Plan Due Date (Optional)")
    ]
    
    var assignToRoleId: String = ""
    
    private var roleId: String = ""
    
    init(roleId: String) {
        if roleId != "3" {
            textFields[2].value = CustomFunction.shared.getKeychain(with: .userId)
        }
        self.roleId = roleId
    }
    
    func setAssignToRoleId(with roleId: String) { assignToRoleId = roleId }
    
    func checkUserRoleProjectManager() -> Bool {
        if roleId == "3" {
            return true
        }
        return false
    }
    
    func insertSubtask(with taskId: String, completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let parentId = taskId // task ID
        let assignTo = assignToRoleId
        let taskName = textFields[0].value
        let taskDesc = textFields[1].value
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMM YYYY"
        let startDate: String = dateFormater.string(from: date)
        let endDate: String = textFields[3].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.insertSubtask(parentId: parentId, assignTo: assignTo, taskName: taskName, taskDesc: taskDesc, startDate: startDate, endDate: endDate), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
    
    func editSubtask(with subtaskId: String, completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let subtaskId = subtaskId
        let assignTo = assignToRoleId
        let taskName = textFields[0].value
        let taskDesc = textFields[1].value
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMM YYYY"
        let startDate: String = dateFormater.string(from: date)
        let endDate: String = textFields[3].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.editSubtask(subTaskId: subtaskId, assignTo: assignTo, taskName: taskName, taskDesc: taskDesc, startDate: startDate, endDate: endDate), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
