//
//  TeamMemberModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 11/05/23.
//

import UIKit
import Common

class TeamMemberModel {
    var userId: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var roleId: String
    var roleName: String
    var dateJoined: String
    var isChecked: Bool
    var isJoined: Bool
    
    init(userId: String, firstName: String, lastName: String, email: String, phone: String, roleId: String, roleName: String, dateJoined: String, isChecked: Bool = false, isJoined: Bool = false) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.roleId = roleId
        self.roleName = roleName
        self.dateJoined = dateJoined
        self.isChecked = isChecked
        self.isJoined = isJoined
    }
}

enum MemberDetailPage {
    case teamDetail
    case projectDetail
    case invite
    
    var type: Int {
        switch self {
        case .teamDetail, .projectDetail:
            return 3
        case .invite:
            return 0
        }
    }
    
    var text: String {
        switch self {
        case .teamDetail, .projectDetail:
            return "DELETE"
        case .invite:
            return "INVITE"
        }
    }
}
