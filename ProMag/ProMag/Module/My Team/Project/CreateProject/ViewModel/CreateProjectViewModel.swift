//
//  CreateProjectViewModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 20/05/23.
//

import Common
import Networking
import AuthManager

class CreateProjectViewModel {
    
    private var projectManagerId: String = ""
    
    var textFields: [UserDataModel] = [
        UserDataModel(value: "", enabled: true, type: .text, isRequired: true, placeholder: "Project Title"),
        UserDataModel(value: "", enabled: true, type: .text, isRequired: true, placeholder: "Description"),
        UserDataModel(value: "", enabled: true, type: .dropdown, isRequired: true, placeholder: "Assign to"),
        UserDataModel(value: "", enabled: true, type: .text, isRequired: false, placeholder: "Plan Due Date (Optional)")
    ]
    
    func setProjectManagerId(id: String) { projectManagerId = id }
    
    func insertProject(completion: @escaping ((ViewState<String>) -> Void)) {
        //Prepare data
        let teamId = CustomFunction.shared.getKeychain(with: .teamId)
        let projectName = textFields[0].value
        let projectDesc = textFields[1].value
        let projectManagerId = projectManagerId
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMM YYYY"
        let startDate: String = dateFormater.string(from: date)
        let endDate: String = textFields[3].value
        
        //Hit API
        completion(.loading)
        NetworkManager.instance.requestObject(ServiceAPI.insertProject(teamId: teamId, projectName: projectName, projectDesc: projectDesc, projectManagerId: projectManagerId, startData: startDate, endDate: endDate), c: SingleResponse<EmptyData>.self) { (result) in
            switch result {
            case .success(let response):
                completion(.success(data: response.message))
            case .failure(let error):
                completion(.error(error: error))
            }
        }
    }
}
