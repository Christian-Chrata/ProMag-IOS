//
//  CreateTaskModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 05/06/23.
//

import Foundation

enum CreateTaskModel {
    case create(projectId: String)
    case edit(taskId: String)
    
    var title: String {
        switch self {
        case .create:
            return "Create Task"
        case .edit:
            return "Edit Task"
        }
    }
    
    var projectId: String {
        switch self {
        case .create(let projectId):
            return projectId
        case .edit:
            return ""
        }
    }
    
    var taskId: String {
        switch self {
        case .create:
            return ""
        case .edit(let taskId):
            return taskId
        }
    }
}
