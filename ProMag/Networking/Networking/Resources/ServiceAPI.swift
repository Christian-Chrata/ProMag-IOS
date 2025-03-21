//
//  ServiceAPI.swift
//  Networking
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public enum ServiceAPI {
    
    // MARK: AUTH
    case login(email: String, password: String)
    case register(name: String, phone: String, email: String, password: String)
    case forgetPassword(email: String)
    case resetPassword(userEmail: String, token: String, password: String)
    case getOTP(email: String)
    case verifyOtp(email: String, otp: String)
    
    // MARK: USER
    case changePassword(id: String, oldPassword: String, newPassword: String)
    case deleteAccount(id: String, password: String)
    case editUserInfo(id: String, username: String, phone: String)
    case editUserEmail(id: String, newEmail: String)
    case verifyUserEmail(id: String, email: String, otp: String)
    case getUserProfile(id: String)
    
    // MARK: TEAM
    case createTeam(name: String, description: String)
    case editTeam(id: String, name: String, description: String)
    case searchMember(teamId: String, query: String)
    case inviteMember(teamId: String, newMemberId: String)
    case getTeamMember(teamId: String)
    case getRoles
    case changeRole(teamId: String, targetId: String, roleId: String)
    case kickTeamMember(teamId: String, toBeKickedId: String)
    case getTeamInfo(teamId: String)
    case leaveTeam(teamId: String)
    
    // MARK: PROJECT
    case getProject(teamId: String)
    case insertProject(teamId: String, projectName: String, projectDesc: String, projectManagerId: String, startData: String, endDate: String)
    case insertUser(projectId: String, targetId: String)
    case getProjectMember(projectId: String)
    case updateProjectInfo(projectId: String, projectName: String, projectDesc: String, newProjectManagerId: String, startDate: String, endDate: String)
    case getProjectInfo(projectId: String)
    case getProjectDashboard(projectId: String)
    case kickProjectMember(projectId: String, targetId: String)
    
    // MARK: TASK
    case insertTask(projectId: String, assignTo: String, taskName: String, taskDesc: String, startDate: String, endDate: String)
    case getTasks(projectId: String)
    case getMyTasks(teamId: String)
    case getTaskDetail(taskId: String)
    case deleteTask(taskId: String)
    case editTask(taskId: String, assignTo: String, taskName: String, taskDesc: String, startDate: String, endDate: String)
    case insertSubtask(parentId: String, assignTo: String, taskName: String, taskDesc: String, startDate: String, endDate: String)
    case deleteSubtask(subtaskId: String)
    case editSubtask(subTaskId: String, assignTo: String, taskName: String, taskDesc: String, startDate: String, endDate: String)
    case processTask(taskId: String)
    
    // MARK: Comment
    case PostComment(taskId: String, comment: String)
    case DeleteComment(commentId: String)
}

extension ServiceAPI: EndPointType {
    public var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .forgetPassword:
            return "/auth/forgotPassword"
        case .resetPassword:
            return "/auth/verifyForgotPassword"
        case .getOTP:
            return "/auth/getOtp"
        case .verifyOtp:
            return "/auth/verifyOtp"
        case .changePassword:
            return "/user/changePassword"
        case .deleteAccount:
            return "/user/deleteAccount"
        case .editUserInfo:
            return "/user/editUserInfo"
        case .editUserEmail:
            return "/user/editUserEmail"
        case .verifyUserEmail:
            return "/user/verifyEditUserEmail"
        case .createTeam:
            return "/team/createTeam"
        case .getUserProfile:
            return "/user/getUserProfile"
        case .editTeam:
            return "/team/editTeam"
        case .searchMember:
            return "/team/searchUser"
        case .inviteMember:
            return "/team/inviteMember"
        case .getTeamMember:
            return "/team/getTeamMembers"
        case .getRoles:
            return "/team/getRoles"
        case .changeRole:
            return "team/changeRole"
        case .kickTeamMember:
            return "/team/kickMember"
        case .getTeamInfo:
            return "/team/getTeamInfo"
        case .getProject:
            return "/project/getProjects"
        case .insertProject:
            return "/project/insertProject"
        case .insertUser:
            return "/project/insertUser"
        case .getProjectMember:
            return "/project/getTeamMembers"
        case .updateProjectInfo:
            return "/project/updateProjectInfo"
        case .getProjectDashboard:
            return "/project/getProjectDashboard"
        case .kickProjectMember:
            return "/project/kickUser"
        case .insertTask:
            return "/task/insertTask"
        case .getTasks:
            return "/task/getTasks"
        case .getMyTasks:
            return "/task/getMyTask"
        case .getTaskDetail:
            return "/task/getTaskDetail"
        case .deleteTask:
            return "/task/deleteTask"
        case .editTask:
            return "/task/editTask"
        case .insertSubtask:
            return "/task/insertSubTask"
        case .deleteSubtask:
            return "/task/deleteSubTask"
        case .editSubtask:
            return "/task/editSubTask"
        case .PostComment:
            return "/comment/postComment"
        case .DeleteComment:
            return "/comment/deleteComment"
        case .getProjectInfo:
            return "/project/getProjectInfo"
        case .leaveTeam:
            return "team/leaveTeam"
        case .processTask:
            return "/task/processTask"
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .deleteAccount,
                .kickTeamMember,
                .kickProjectMember,
                .deleteTask,
                .deleteSubtask,
                .DeleteComment,
                .leaveTeam:
            return .delete
        case .editUserEmail,
                .editUserInfo,
                .editTeam,
                .changePassword,
                .changeRole,
                .editTask,
                .editSubtask,
                .processTask:
            return .patch
        case .getUserProfile,
                .getTeamMember,
                .getRoles,
                .searchMember,
                .getTeamInfo,
                .getProject,
                .getProjectMember,
                .getTasks,
                .getMyTasks,
                .getTaskDetail,
                .getProjectInfo,
                .getProjectDashboard:
            return .get
        default:
            return .post
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .login(let email, let password):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(email), name: "userEmail"))
            multipartFormData.append(MultipartFormData(provider: .text(password), name: "password"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .register(let name, let phone, let email, let password):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(name), name: "userFullname"))
            multipartFormData.append(MultipartFormData(provider: .text(email), name: "userEmail"))
            multipartFormData.append(MultipartFormData(provider: .text(phone), name: "userPhone"))
            multipartFormData.append(MultipartFormData(provider: .text(password), name: "password"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .forgetPassword(let email):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(email), name: "userEmail"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .resetPassword(let userEmail, let token, let password):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(userEmail), name: "userEmail"))
            multipartFormData.append(MultipartFormData(provider: .text(token), name: "token"))
            multipartFormData.append(MultipartFormData(provider: .text(password), name: "newPassword"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .getOTP(let email):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(email), name: "userEmail"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .verifyOtp(let email, let otp):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(email), name: "userEmail"))
            multipartFormData.append(MultipartFormData(provider: .text(otp), name: "otp"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .changePassword(let id, let oldPassword, let newPassword):
            let json : [String : Any] = [
                "userId" : id,
                "oldPassword" : oldPassword,
                "newPassword" : newPassword,
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .deleteAccount(let id, let password):
            let json : [String : Any] = [
                "userId" : id,
                "password" : password
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .editUserInfo(let id, let username, let phone):
            let json : [String : Any] = [
                "userId" : id,
                "userFullname" : username,
                "userPhone" : phone,
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .editUserEmail(let id, let newEmail):
            let json : [String : Any] = [
                "userId" : id,
                "userEmail" : newEmail
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .verifyUserEmail(let id, let email, let otp):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(id), name: "userId"))
            multipartFormData.append(MultipartFormData(provider: .text(email), name: "userEmail"))
            multipartFormData.append(MultipartFormData(provider: .text(otp), name: "otp"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .createTeam(let name, let description):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(name), name: "teamName"))
            multipartFormData.append(MultipartFormData(provider: .text(description), name: "teamDesc"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .getUserProfile(let id):
            let json : [String : Any] = [
                "userId" : id
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .editTeam(let id, let name, let description):
            let json : [String : Any] = [
                "teamId" : id,
                "newTeamName" : name,
                "newTeamDesc" : description
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .searchMember(let teamId, let query):
            let json : [String : Any] = [
                "teamId" : teamId,
                "query" : query
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .inviteMember(let teamId, let newMemberId):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(teamId), name: "teamId"))
            multipartFormData.append(MultipartFormData(provider: .text(newMemberId), name: "newMemberId"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .getTeamMember(let teamId):
            let json : [String : Any] = [
                "teamId" : teamId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .getRoles:
            let json : [String : AnyObject] = [ : ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .changeRole(let teamId, let targetId, let roleId):
            let json : [String : Any] = [
                "teamId" : teamId,
                "targetId" : targetId,
                "roleId" : roleId
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .insertUser(projectId: let projectId, targetId: let targetId):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(projectId), name: "projectId"))
            multipartFormData.append(MultipartFormData(provider: .text(targetId), name: "targetId"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .getProjectMember(projectId: let projectId):
            let json : [String : Any] = [
                "projectId" : projectId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .updateProjectInfo(projectId: let projectId, projectName: let projectName, projectDesc: let projectDesc, newProjectManagerId: let newProjectManagerId, startDate: let startDate, endDate: let endDate):
            let json : [String : Any] = [
                "projectId" : projectId,
                "projectName" : projectName,
                "projectDesc" : projectDesc,
                "newProjectManagerId" : newProjectManagerId,
                "startDate" : startDate,
                "endDate" : endDate
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .insertTask(projectId: let projectId, assignTo: let assignTo, taskName: let taskName, taskDesc: let taskDesc, startDate: let startDate, endDate: let endDate):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(projectId), name: "projectId"))
            multipartFormData.append(MultipartFormData(provider: .text(assignTo), name: "assignTo"))
            multipartFormData.append(MultipartFormData(provider: .text(taskName), name: "taskName"))
            multipartFormData.append(MultipartFormData(provider: .text(taskDesc), name: "taskDesc"))
            multipartFormData.append(MultipartFormData(provider: .text(startDate), name: "startDate"))
            multipartFormData.append(MultipartFormData(provider: .text(endDate), name: "endDate"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .getTasks(projectId: let projectId):
            let json : [String : Any] = [
                "projectId" : projectId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .getMyTasks(let teamId):
            let json : [String : Any] = [
                "teamId" : teamId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .getTaskDetail(taskId: let taskId):
            let json : [String : Any] = [
                "taskId" : taskId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .deleteTask(taskId: let taskId):
            let json : [String : Any] = [
                "taskId" : taskId
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .editTask(let taskId, let assignTo, let taskName, let taskDesc, let startDate, let endDate):
            let json : [String : Any] = [
                "taskId" : taskId,
                "assignTo" : assignTo,
                "taskName" : taskName,
                "taskDesc" : taskDesc,
                "startDate" : startDate,
                "endDate" : endDate
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .insertSubtask(parentId: let parentId, assignTo: let assignTo, taskName: let taskName, taskDesc: let taskDesc, startDate: let startDate, endDate: let endDate):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(parentId), name: "parentId"))
            multipartFormData.append(MultipartFormData(provider: .text(assignTo), name: "assignTo"))
            multipartFormData.append(MultipartFormData(provider: .text(taskName), name: "taskName"))
            multipartFormData.append(MultipartFormData(provider: .text(taskDesc), name: "taskDesc"))
            multipartFormData.append(MultipartFormData(provider: .text(startDate), name: "startDate"))
            multipartFormData.append(MultipartFormData(provider: .text(endDate), name: "endDate"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .deleteSubtask(subtaskId: let subtaskId):
            let json : [String : Any] = [
                "subTaskId" : subtaskId
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .editSubtask(subTaskId: let subTaskId, assignTo: let assignTo, taskName: let taskName, taskDesc: let taskDesc, startDate: let startDate, endDate: let endDate):
            let json : [String : Any] = [
                "subTaskId" : subTaskId,
                "assignTo" : assignTo,
                "taskName" : taskName,
                "taskDesc" : taskDesc,
                "startDate" : startDate,
                "endDate" : endDate
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .processTask(let taskId):
            let json : [String : Any] = [
                "taskId" : taskId
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .PostComment(taskId: let taskId, comment: let comment):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(taskId), name: "taskId"))
            multipartFormData.append(MultipartFormData(provider: .text(comment), name: "comment"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .DeleteComment(commentId: let commentId):
            let json : [String : Any] = [
                "commentId" : commentId
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .kickTeamMember(let teamId, let toBeKickedId):
            let json : [String : Any] = [
                "teamId" : teamId,
                "toBeKickedId" : toBeKickedId
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .kickProjectMember(let projectId, let targetId):
            let json : [String : Any] = [
                "projectId" : projectId,
                "targetId" : targetId
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        case .getTeamInfo(let teamId):
            let json : [String : Any] = [
                "teamId" : teamId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .getProject(let teamId):
            let json : [String : Any] = [
                "teamId" : teamId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .insertProject(let teamId, let projectName, let projectDesc, let projectManagerId, let startData, let endDate):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .text(teamId), name: "teamId"))
            multipartFormData.append(MultipartFormData(provider: .text(projectName), name: "projectName"))
            multipartFormData.append(MultipartFormData(provider: .text(projectDesc), name: "projectDesc"))
            multipartFormData.append(MultipartFormData(provider: .text(projectManagerId), name: "projectManagerId"))
            multipartFormData.append(MultipartFormData(provider: .text(startData), name: "startDate"))
            multipartFormData.append(MultipartFormData(provider: .text(endDate), name: "endDate"))
            return .uploadMultipart(multipartFormData: multipartFormData)
        case .getProjectInfo(let projectId):
            let json : [String : Any] = [
                "projectId" : projectId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .getProjectDashboard(let projectId):
            let json : [String : Any] = [
                "projectId" : projectId
            ]
            return .requestCompositeParameters(bodyParameters: json, bodyEncoding: .urlEncoding, urlParameters: json)
        case .leaveTeam(let teamId):
            let json : [String : Any] = [
                "teamId" : teamId
            ]
            return .requestParameters(parameters: json, encoding: .jsonEncoding)
        }
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return getSampleJSONAsData(with: "MockResponse")
        }
    }
}

extension ServiceAPI {
    private func getSampleJSONAsData(with name: String) -> Data {
        guard let path = Bundle(identifier: "com.chrata.Networking")?.path(forResource: name, ofType: "json") else {
            fatalError("File not found")
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            return Data()
        }
    }
}
