//
//  CreateSubtaskController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 08/06/23.
//

import UIKit
import Common

class CreateSubtaskController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleField: TextField!
    @IBOutlet weak var descriptionField: TextField!
    @IBOutlet weak var assignField: TextField!
    @IBOutlet weak var dueField: TextField!
    @IBOutlet weak var submitButton: UIButton!
    let datePicker = UIDatePicker()
    
    private var viewModel = CreateSubtaskViewModel(roleId: "")
    private var state: CreateSubtaskModel = .create(taskId: "")
    
    init(viewModel: CreateSubtaskViewModel, state: CreateSubtaskModel) {
        super.init(nibName: "CreateSubtaskController", bundle: Bundle(for: CreateSubtaskController.self))
        self.viewModel = viewModel
        self.state = state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        submitButton.addTarget(self, action: #selector(onTapSubmit(_:)), for: .touchUpInside)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [
            titleField,
            descriptionField,
            assignField,
            dueField
        ]
            .enumerated()
            .forEach { (offset, textField) in
                textField?.delegate = self
                textField?.type = self.viewModel.textFields[offset].type
                textField?.isRequired = self.viewModel.textFields[offset].isRequired
                textField?.isEnabled = self.viewModel.textFields[offset].enabled
                textField?.placeholder = self.viewModel.textFields[offset].placeholder
                textField?.text = self.viewModel.textFields[offset].value
                textField?.setup()
        }
        
        if viewModel.checkUserRoleProjectManager() {
            assignField.isHidden = false
        } else {
            assignField.isHidden = true
        }
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = .current
        dueField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dueDateChange(_:)), for: .valueChanged)
        
        title = state.title
    }
    
    @objc func onTapSubmit(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        [
            titleField,
            descriptionField,
            assignField,
            dueField
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
        
        switch state {
        case .create:
            viewModel.insertSubtask(with: state.taskId) { (state) in
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
            viewModel.editSubtask(with: state.subtaskId) { (state) in
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
    
    @objc private func dueDateChange(_ sender: UITextField) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMM YYYY"
        dueField.text = dateFormater.string(from: datePicker.date)
    }
}

extension CreateSubtaskController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case assignField:
            textField.resignFirstResponder()
            let viewController = SelectTeamController(state: .single, viewModel: SelectTeamViewModel())
            viewController.delegate = self
            navigationController?.present(viewController, animated: true)
        case dueField:
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd MMM YYYY"
            dueField.text = dateFormater.string(from: datePicker.date)
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case titleField:
            descriptionField.becomeFirstResponder()
        case descriptionField:
            if viewModel.checkUserRoleProjectManager() {
                assignField.becomeFirstResponder()
            } else {
                dueField.becomeFirstResponder()
            }
        case assignField:
            dueField.becomeFirstResponder()
        case dueField:
            textField.resignFirstResponder()
            submit()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

extension CreateSubtaskController: SelectTeamControllerDelegate {
    func selectTeam(id: String, name: String) {
        viewModel.setAssignToRoleId(with: id)
        viewModel.textFields[2].value = name
        assignField.text = name
    }
}
