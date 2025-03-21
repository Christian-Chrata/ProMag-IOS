//
//  TaskModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/05/23.
//

import Foundation

class TaskModel {
    var projectId: String
    var projectName: String
    var id: String
    var userId: String
    var userFullname: String
    var title: String
    var desc: String
    var startDate: String
    var endDate: String
    var status: String
    
    init(projectId: String, projectName: String, id: String, userId: String, userFullname: String, title: String, desc: String, startDate: String, endDate: String, status: String) {
        self.projectId = projectId
        self.projectName = projectName
        self.id = id
        self.userId = userId
        self.userFullname = userFullname
        self.title = title
        self.desc = desc
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
    }
}

enum TaskSortingState {
    case alphabet
    case date
}
