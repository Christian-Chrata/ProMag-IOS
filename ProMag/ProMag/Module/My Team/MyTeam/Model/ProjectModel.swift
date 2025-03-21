//
//  MyTeamModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 08/05/23.
//

import UIKit
import Common

class ProjectModel {
    var projectId: String
    var teamId: String
    var pmName: String
    var projectName: String
    var projectDesc: String
    var status: String
    var projectStartdate: String
    var projectEnddate: String
    
    init(projectId: String, teamId: String, pmName: String, projectName: String, projectDesc: String, status: String, projectStartdate: String, projectEnddate: String) {
        self.projectId = projectId
        self.teamId = teamId
        self.pmName = pmName
        self.projectName = projectName
        self.projectDesc = projectDesc
        self.status = status
        self.projectStartdate = projectStartdate
        self.projectEnddate = projectEnddate
    }
}
