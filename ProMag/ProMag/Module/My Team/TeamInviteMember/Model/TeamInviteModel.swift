//
//  TeamInviteModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 15/05/23.
//

import Foundation

class TeamInviteModel {
    var userId: String
    var userFirstName: String
    var userLastName: String
    var userEmail: String
    var userPhone: String
    
    init(userId: String, userFirstName: String, userLastName: String, userEmail: String, userPhone: String) {
        self.userId = userId
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userEmail = userEmail
        self.userPhone = userPhone
    }
}
