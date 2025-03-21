//
//  ConfirmForgetPasswordController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 03/04/23.
//

import UIKit
import Common

class ConfirmForgetPasswordController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var password: TextField!
    @IBOutlet weak var confirmPassword: TextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var viewModel = ConfrmForgetPasswordViewModel(email: "", token: "")
    
    init(with viewModel: ConfrmForgetPasswordViewModel) {
        super.init(nibName: "ConfirmForgetPasswordController", bundle: Bundle(for: ConfirmForgetPasswordController.self))
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [
            password,
            confirmPassword
        ]
            .enumerated()
            .forEach { (offset, textField) in
                textField?.delegate = self
                textField?.isEnabled = self.viewModel.textFields[offset].enabled
                textField?.type = self.viewModel.textFields[offset].type
                textField?.isRequired = self.viewModel.textFields[offset].isRequired
                textField?.isEnabled = self.viewModel.textFields[offset].enabled
                textField?.placeholder = self.viewModel.textFields[offset].placeholder
                textField?.text = self.viewModel.textFields[offset].value
                textField?.setup()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Forgot Password"
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        submitButton.addTarget(self, action: #selector(onTapSubmit(_:)), for: .touchUpInside)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
    }
    
    @objc func onTapSubmit(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        [
            password,
            confirmPassword
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
        
        guard password.text == confirmPassword.text else {
            let alert = AlertController(with: .warning(message: "The password and confirmation password do not match."))
            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: nil))
            alert.show()
            return
        }
        
        viewModel.resetPassword { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success(let message):
                    LoadingController.shared.dismiss()
                    let alert = AlertController(with: .success(message: message))
                    alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                        self?.navigationController?.setViewControllers([LoginController()], animated: true)
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

extension ConfirmForgetPasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case password:
            confirmPassword.becomeFirstResponder()
        case confirmPassword:
            textField.resignFirstResponder()
            submit()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
