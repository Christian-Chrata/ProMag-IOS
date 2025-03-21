//
//  MyProfileModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 21/04/23.
//

import UIKit
import Common

enum TeamListType {
    case active
    case deactive
    
    var viewColor: UIColor {
        switch self {
        case .active:
            return Color.primary
        case .deactive:
            return Color.white
        }
    }
    
    var labelColor: UIColor {
        switch self {
        case .active:
            return Color.primary
        case .deactive:
            return UIColor.label
        }
    }
}

class TeamListModel {
    var id: String
    var name: String
    var desc: String
    var type: TeamListType
    
    init(id: String, name: String, desc: String, type: TeamListType) {
        self.id = id
        self.name = name
        self.desc = desc
        self.type = type
    }
}
