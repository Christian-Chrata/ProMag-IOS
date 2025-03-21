//
//  CreateSubtaskModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 08/06/23.
//

import Foundation

enum CreateSubtaskModel {
    case create(taskId: String)
    case edit(subtaskId: String)
    
    var title: String {
        switch self {
        case .create:
            return "Create Task"
        case .edit:
            return "Edit Task"
        }
    }
    
    var taskId: String {
        switch self {
        case .create(let taskId):
            return taskId
        case .edit:
            return ""
        }
    }
    
    var subtaskId: String {
        switch self {
        case .create:
            return ""
        case .edit(let subtaskId):
            return subtaskId
        }
    }
}
