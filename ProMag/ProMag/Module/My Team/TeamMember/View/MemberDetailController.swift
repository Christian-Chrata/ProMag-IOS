//
//  MemberDetailController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 12/05/23.
//

import UIKit
import Common

protocol MemberDetailControllerDelegate {
    func onDismiss()
}

class MemberDetailController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var assignView: UIView!
    @IBOutlet weak var assignLbl: UILabel!
    @IBOutlet weak var rolesStack: UIStackView!
    @IBOutlet weak var rolesLbl: UILabel!
    @IBOutlet weak var rolesField: TextField!
    @IBOutlet weak var submitButton: Button!
    
    private var viewModel = MemberDetailViewModel(userRoleId: "")
    private var page = MemberDetailPage.teamDetail
    private var pickerView = UIPickerView()
    var delegate: MemberDetailControllerDelegate?
    
    init(with viewModel: MemberDetailViewModel, page: MemberDetailPage) {
        super.init(nibName: "MemberDetailController", bundle: Bundle(for: MemberDetailController.self))
        self.viewModel = viewModel
        self.page = page
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        submitButton.addTarget(self, action: #selector(onTapSubmit(_:)), for: .touchUpInside)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
        
        switch page {
        case .teamDetail:
            viewModel.getRoles { (state) in
                DispatchQueue.main.async { [weak self] in
                    switch state {
                    case .loading:
                        LoadingController.shared.show()
                    case .success:
                        LoadingController.shared.dismiss()
                    case .error(let error):
                        LoadingController.shared.dismiss()
                        self?.show(with: error, completion: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        case .projectDetail, .invite: break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initialLbl.text = viewModel.getInitial()
        firstNameLbl.text = viewModel.getFirstName()
        lastNameLbl.text = viewModel.getLastName()
        emailLbl.text = viewModel.getEmail()
        phoneLbl.text = viewModel.getPhone()
        assignLbl.text = viewModel.getAssignDate()
        rolesLbl.text = viewModel.textFields[0].value
        submitButton.type = page.type
        submitButton.setTitle(page.text, for: .normal)
        submitButton.setup()
        
        [
            rolesField
        ]
            .enumerated()
            .forEach { (offset, textField) in
                textField?.delegate = self
                textField?.type = self.viewModel.textFields[offset].type
                textField?.isRequired = self.viewModel.textFields[offset].isRequired
                textField?.isEnabled = self.viewModel.textFields[offset].enabled
                textField?.placeholder = self.viewModel.textFields[offset].placeholder
                textField?.text = self.viewModel.textFields[offset].value
                textField?.inputView = self.pickerView
                textField?.setup()
        }
        
        switch page {
        case .teamDetail:
            rolesField.isHidden = viewModel.isHideEdit(with: page)
            rolesLbl.isHidden = !viewModel.isHideEdit(with: page)
            assignView.isHidden = false
        case .projectDetail:
            rolesField.isHidden = true
            rolesLbl.isHidden = false
            assignView.isHidden = false
        case .invite:
            rolesStack.isHidden = true
            assignView.isHidden = true
        }
        
        submitButton.isHidden = viewModel.isHideEdit(with: page)
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let delegate = delegate else { return }
        delegate.onDismiss()
    }
    
    @objc func onTapSubmit(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        switch page {
        case .invite:
            viewModel.inviteMember { (state) in
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
        case .teamDetail:
            [
                rolesField
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
            
            viewModel.kickTeamMember { (state) in
                DispatchQueue.main.async { [weak self] in
                    switch state {
                    case .loading:
                        LoadingController.shared.show()
                    case .success(let message):
                        LoadingController.shared.dismiss()
                        let alert = AlertController(with: .success(message: message))
                        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                            self?.dismiss(animated: true)
                        }))
                        alert.show()
                    case .error(let error):
                        LoadingController.shared.dismiss()
                        self?.show(with: error)
                    }
                }
            }
            
        case .projectDetail:
            [
                rolesField
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
            
            viewModel.kickProjectMember { (state) in
                DispatchQueue.main.async { [weak self] in
                    switch state {
                    case .loading:
                        LoadingController.shared.show()
                    case .success(let message):
                        LoadingController.shared.dismiss()
                        let alert = AlertController(with: .success(message: message))
                        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                            self?.dismiss(animated: true)
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

extension MemberDetailController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case rolesField:
            textField.resignFirstResponder()
            submit()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.changeRole { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
}

extension MemberDetailController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getRolesCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getRolesAtRow(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rolesField.text = viewModel.getRolesAtRow(row: row)
    }
}
