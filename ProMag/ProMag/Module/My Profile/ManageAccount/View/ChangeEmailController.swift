//
//  ChangeEmailController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 02/05/23.
//

import UIKit
import Common
import Networking

class ChangeEmailController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentEmail: TextField!
    @IBOutlet weak var newEmail: TextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var viewModel = ChangeEmailViewModel()
    
    init() {
        super.init(nibName: "ChangeEmailController", bundle: Bundle(for: ChangeEmailController.self))
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
            currentEmail,
            newEmail
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
        
        title = "Change Email"
    }
    
    @objc func onTapSubmit(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        [
            currentEmail,
            newEmail
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
        
        
        let otpViewModel = OTPViewModel(with: viewModel.getEmail())
        let otp = OTPController(with: otpViewModel)
        otp.delegate = self
        otp.show()
    }
}

extension ChangeEmailController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case currentEmail:
            newEmail.becomeFirstResponder()
        case newEmail:
            textField.resignFirstResponder()
            submit()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

extension ChangeEmailController: OTPControllerDelegate {
    func success(with message: String) {
        
        self.viewModel.changeEmail { (state) in
            switch state {
            case .loading:
                LoadingController.shared.show()
            case .success(let message):
                LoadingController.shared.dismiss()
                let alert = AlertController(with: .success(message: message))
                alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.show()
            case .error(let error):
                LoadingController.shared.dismiss()
                self.show(with: error)
            }
        }
    }
    
    func error(with error: NetworkError) {
        self.show(with: error)
    }
    
    func sentOTP(completion: @escaping ((ViewState<Void>) -> Void)) {
        viewModel.changeEmail { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    completion(.success(data: ()))
                    LoadingController.shared.dismiss()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
    
    func submit(with otp: String) {
        viewModel.verifyEmail(otp: otp) { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success(let message):
                    LoadingController.shared.dismiss()
                    self?.dismiss(animated: true) {
                        let alert = AlertController(with: .success(message: message))
                        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                            self?.navigationController?.setViewControllers([LoginController()], animated: true)
                        }))
                        alert.show()
                    }
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
}
