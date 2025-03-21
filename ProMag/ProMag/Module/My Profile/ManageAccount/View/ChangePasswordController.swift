//
//  ChangePasswordController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 30/04/23.
//

import UIKit
import Common

class ChangePasswordController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentPass: TextField!
    @IBOutlet weak var newPass: TextField!
    @IBOutlet weak var confirmNewPass: TextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var viewModel = ChangePasswordViewModel()
    
    init() {
        super.init(nibName: "ChangePasswordController", bundle: Bundle(for: ChangePasswordController.self))
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
            currentPass,
            newPass,
            confirmNewPass
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
        
        title = "Change Password"
    }
    
    @objc func onTapSubmit(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        [
            currentPass,
            newPass,
            confirmNewPass
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
        
        guard newPass.text == confirmNewPass.text else {
            let alert = AlertController(with: .warning(message: "The password and confirmation password do not match."))
            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: nil))
            alert.show()
            return
        }
        
        viewModel.changePassword { (state) in
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

extension ChangePasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case currentPass:
            newPass.becomeFirstResponder()
        case newPass:
            confirmNewPass.becomeFirstResponder()
        case confirmNewPass:
            textField.resignFirstResponder()
            submit()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
