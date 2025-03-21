//
//  DashboardModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/05/23.
//

import Foundation

class DashboardModel {
    var completedTask: Int
    var totalTask: Int
    var percentage: Int
    var totalMember: Int
    
    init(completedTask: Int, totalTask: Int, percentage: Int, totalMember: Int) {
        self.completedTask = completedTask
        self.totalTask = totalTask
        self.percentage = percentage
        self.totalMember = totalMember
    }
}
