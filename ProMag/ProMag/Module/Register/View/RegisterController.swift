//
//  RegisterController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 06/01/23.
//

import UIKit
import Common
import Networking

class RegisterController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fNameText: TextField!
    @IBOutlet weak var lNameText: TextField!
    @IBOutlet weak var phoneText: TextField!
    @IBOutlet weak var emailText: TextField!
    @IBOutlet weak var passText: TextField!
    @IBOutlet weak var cPassText: TextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    private var viewModel = RegisterViewModel()
    
    init() {
        super.init(nibName: "RegisterController", bundle: Bundle(for: RegisterController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [
            fNameText,
            lNameText,
            phoneText,
            emailText,
            passText,
            cPassText
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
        
        loginLabel.isUserInteractionEnabled = true
        
        loginLabel.attributedText = UILabel.buildAttributtedString(with: [
            Attr(text: "Already have an account? ? ", size: 16, weight: .regular, color: Color.label),
            Attr(text: "Sign In", size: 16, weight: .medium, color: Color.primary)
        ])
        let tapLogin = UITapGestureRecognizer(target: self, action: #selector(onTapLogin(_:)))
        
        registerButton.addTarget(self, action: #selector(onTapRegister(_:)), for: .touchUpInside)
        loginLabel.addGestureRecognizer(tapLogin)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
    }
    
    @objc func onTapRegister(_ sender: UIButton) {
        register()
    }
    
    private func register() {
        [
            fNameText,
            lNameText,
            phoneText,
            emailText,
            passText,
            cPassText
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
        
        guard passText.text == cPassText.text else {
            let alert = AlertController(with: .warning(message: "The password and confirmation password do not match."))
            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: nil))
            alert.show()
            return
        }
        
        viewModel.register { (state) in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    // show OTP
                    let otpViewModel = OTPViewModel(with: self.viewModel.getEmail())
                    let otp = OTPController(with: otpViewModel)
                    otp.delegate = self
                    otp.show()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self.show(with: error)
                }
            }
        }
    }
    
    @objc
    private func onTapLogin(_ sender: UITapGestureRecognizer) {
        navigationController?.setViewControllers([LoginController()], animated: true)
    }
}

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fNameText:
            lNameText.becomeFirstResponder()
        case lNameText:
            phoneText.becomeFirstResponder()
        case phoneText:
            emailText.becomeFirstResponder()
        case emailText:
            passText.becomeFirstResponder()
        case passText:
            cPassText.resignFirstResponder()
        case cPassText:
            textField.resignFirstResponder()
            self.register()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

extension RegisterController: OTPControllerDelegate {
    func sentOTP(completion: @escaping ((ViewState<Void>) -> Void)) {
        viewModel.getOTP { (state) in
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
        viewModel.verifyOtp(otp: otp) { (state) in
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
