//
//  GetAllUserResponse.swift
//  Networking
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public struct LoginResponse: Codable {
    public let userInfo: UserInfo?
    public let userTeamId: [UserTeamId]?
    public let accessToken: String?
    
    public struct UserInfo: Codable {
        public let userId: Int?
        public let userFullname: String?
        public let userEmail: String?
        public let userPhone: String?
    }
    
    public struct UserTeamId: Codable {
        public let teamId: String?
        public let teamName: String?
        public let roleId: String?
    }
}

public struct GetUserProfileResponse: Codable {
    public let userId: Int
    public let userFullname: String
    public let userEmail: String
    public let userPhone: String
    public let userTeams: [UserTeams]
    
    public struct UserTeams: Codable {
        public let teamId: String
        public let teamName: String
        public let teamDesc: String
        public let roleId: String
        public let dateJoined: String
    }
}

public struct GetTeamMemberResponse: Codable {
    public let teamMembers: [TeamMembers]
    
    public struct TeamMembers: Codable {
        public let userId: String
        public let userFullname: String
        public let userEmail: String
        public let userPhone: String
        public let roleId: String
        public let roleName: String
        public let dateJoined: String
    }
}

public struct getRolesResponse: Codable {
    public let roles: [roleType]
    
    public struct roleType: Codable {
        public let roleId: Int
        public let roleName: String
    }
}

public struct searchMemberResponse: Codable {
    public let users: [usersModel]
    
    public struct usersModel: Codable {
        public let userId: Int
        public let userFullname: String
        public let userEmail: String
        public let userPhone: String
    }
}

public struct getProjectResponse: Codable {
    public let projects: [ProjectModel]
    
    public struct ProjectModel: Codable {
        public let projectManager: String
        public let projectId: String
        public let teamId: String
        public let projectName: String
        public let projectDesc: String
        public let status: String
        public let projectStartdate: String
        public let projectEnddate: String
    }
}


public struct getTeamInfoResponse: Codable {
    public let teamId: String
    public let teamName: String
    public let roleId: String
    public let roleName: String
}

public struct getProjectInfoResponse: Codable {
    public let projectId: Int
    public let projectName: String
    public let projectDesc: String
    public let members: [MemberModel]
    
    public struct MemberModel: Codable {
        public let userId: String
        public let userFullname: String
        public let userEmail: String
        public let userPhone: String
        public let roleId: String
        public let roleName: String
        public let assignDate: String
    }
}

public struct getProjectMemberResponse: Codable {
    public let members: [MemberModel]
    
    public struct MemberModel: Codable {
        public let userId: String
        public let userFullname: String
        public let alreadyExist: String
    }
}


public struct getTasksResponse: Codable {
    public let tasks: [tasks]
    
    public struct tasks: Codable {
        public let projectId: String
        public let projectName: String
        public let taskId: String
        public let userFullname: String?
        public let taskName: String
        public let taskDesc: String
        public let status: String
        public let taskStartdate: String
        public let taskEnddate: String
    }
}

public struct getProjectTasksResponse: Codable {
    public let projectData: projectData
    public let userData: userData
    public let tasks: [tasks]
    
    public struct projectData: Codable {
        public let projectId: String
        public let projectName: String
    }
    
    public struct userData: Codable {
        public let roleId: String
        public let roleName: String
    }
    
    public struct tasks: Codable {
        public let taskId: String
        public let userFullname: String
        public let taskName: String
        public let taskDesc: String
        public let status: String
        public let taskStartdate: String
        public let taskEnddate: String
    }
}

public struct getDashboardResponse: Codable {
    public let completedTask: Int
    public let totalTask: Int
    public let percentage: Int
    public let totalMember: Int
}


public struct getTaskDetailResponse: Codable {
    public let projectData: projectData
    public let userData: userData?
    public let task: task
    
    public struct projectData: Codable {
        public let projectId: String
        public let projectName: String
    }
    
    public struct userData: Codable {
        public let roleId: String
        public let roleName: String
    }
    
    public struct task: Codable {
        public let taskId: String
        public let userFullname: String
        public let userId: String
        public let taskName: String
        public let taskDesc: String
        public let status: String
        public let taskStartdate: String
        public let taskEnddate: String
        public let subtask: [subtask]
        public let comments: [comments]
    }
    
    public struct subtask: Codable {
        public let projectId: String
        public let projectName: String
        public let taskId: String
        public let userFullname: String
        public let taskName: String
        public let taskDesc: String
        public let status: String
        public let taskStartdate: String
        public let taskEnddate: String
    }
    
    public struct comments: Codable {
        public let commentId: String
        public let comment: String
        public let userId: String
        public let userFullname: String
        public let commentPostdate: String
    }
}
