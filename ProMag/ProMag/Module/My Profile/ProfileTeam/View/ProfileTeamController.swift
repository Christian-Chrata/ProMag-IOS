//
//  ProfileTeamController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 22/04/23.
//

import UIKit
import Common

class ProfileTeamController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var teamName: TextField!
    @IBOutlet weak var teamDescription: TextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var viewModel = ProfileTeamViewModel()
    private var type: ProfileTeamType = .create
    
    init(with type: ProfileTeamType) {
        super.init(nibName: "ProfileTeamController", bundle: Bundle(for: ProfileTeamController.self))
        self.type = type
        viewModel.getTeamData(id: type.id, name: type.name, description: type.description)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = type.title
        
        switch type {
        case .create: break
        case .edit:
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(onTapMenu(_:)))
        }
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        submitButton.addTarget(self, action: #selector(onTapSubmit(_:)), for: .touchUpInside)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [
            teamName,
            teamDescription
        ]
            .enumerated()
            .forEach { (offset, textField) in
                textField?.delegate = self
                textField?.type = self.viewModel.textFields[offset].type
                textField?.isRequired = self.viewModel.textFields[offset].isRequired
                textField?.placeholder = self.viewModel.textFields[offset].placeholder
                textField?.isEnabled = self.viewModel.textFields[offset].enabled
                textField?.text = self.viewModel.textFields[offset].value
                textField?.setup()
        }
        
        switch type {
        case .create:
            self.submitButton.setTitle("CREATE", for: .normal)
        case .edit:
            self.submitButton.setTitle("SAVE", for: .normal)
        }
    }
    
    @objc func onTapSubmit(_ sender: UIButton) {
        submit()
    }
    
    @objc func onTapMenu(_ sender: UIButton) {
        let menu = MenuController()
        menu.addAction(MenuAction(title: "LEAVE TEAM", type: .danger, completion: {
            self.viewModel.deleteTeam { (state) in
                DispatchQueue.main.async { [weak self] in
                    switch state {
                    case .loading:
                        LoadingController.shared.show()
                    case .success(let message):
                        LoadingController.shared.dismiss()
                        let alert = AlertController(with: .success(message: message))
                        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                            self?.navigationController?.popViewController(animated: true)
                        }))
                        alert.show()
                    case .error(let error):
                        LoadingController.shared.dismiss()
                        self?.show(with: error)
                    }
                }
            }
        }))
        
        menu.addAction(MenuAction(title: "CANCEL", type: .secondary, completion: nil))
        menu.show()
    }
    
    private func submit() {
        [
            teamName,
            teamDescription
        ].enumerated().forEach{ (offset, textField) in
            guard let value = textField?.value() else { return }
            self.viewModel.textFields[offset].value = value
            textField?.validate()
            textField?.resignFirstResponder()
        }

        guard CustomFunction.shared.validate(with: viewModel.textFields) else {
            let alert = AlertController(with: .warning(message: CustomFunction.shared.getError()))
            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: nil))
            alert.show()
            return
        }
        
        switch type {
        case .create:
            viewModel.createTeam { (state) in
                DispatchQueue.main.async { [weak self] in
                    switch state {
                    case .loading:
                        LoadingController.shared.show()
                    case .success(let message):
                        LoadingController.shared.dismiss()
                        let alert = AlertController(with: .success(message: message))
                        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                            self?.navigationController?.popViewController(animated: true)
                        }))
                        alert.show()
                    case .error(let error):
                        LoadingController.shared.dismiss()
                        self?.show(with: error)
                    }
                }
            }
        case .edit:
            viewModel.updateTeam { (state) in
                DispatchQueue.main.async { [weak self] in
                    switch state {
                    case .loading:
                        LoadingController.shared.show()
                    case .success(let message):
                        LoadingController.shared.dismiss()
                        let alert = AlertController(with: .success(message: message))
                        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                            self?.navigationController?.popViewController(animated: true)
                        }))
                        alert.show()
                    case .error(let error):
                        LoadingController.shared.dismiss()
                        self?.show(with: error)
                    }
                }
            }
        }
    }
}

extension ProfileTeamController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case teamName:
            teamDescription.becomeFirstResponder()
        case teamDescription:
            textField.resignFirstResponder()
            submit()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
