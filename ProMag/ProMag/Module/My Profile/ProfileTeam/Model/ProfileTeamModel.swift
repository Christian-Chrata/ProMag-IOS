//
//  ProfileTeamModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/04/23.
//

import Foundation

enum ProfileTeamType {
    case create
    case edit(id: String, title: String, description: String)
    
    var id: String {
        switch self {
        case .create:
            return ""
        case .edit(let id, _, _):
            return id
        }
    }
    
    var title: String {
        switch self {
        case .create:
            return "Create Team"
        case .edit(_, let title, _):
            return title
        }
    }
    
    var name: String {
        switch self {
        case.create:
            return ""
        case .edit(_, let title, _):
            return title
        }
    }
    var description: String {
        switch self {
        case .create:
            return ""
        case .edit(_, _, let description):
            return description
        }
    }
}
