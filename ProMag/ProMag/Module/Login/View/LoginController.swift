//
//  LoginController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 04/01/23.
//

import UIKit
import Common

class LoginController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailText: TextField!
    @IBOutlet weak var passText: TextField!
    @IBOutlet weak var forgetLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    
    private var viewModel = LoginViewModel()
    
    init() {
        super.init(nibName: "LoginController", bundle: Bundle(for: LoginController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [
            emailText,
            passText
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
        
        [
            forgetLabel,
            registerLabel
        ]
            .enumerated()
            .forEach { (offset, label) in
                label?.isUserInteractionEnabled = true
            }
        
        let tapForget = UITapGestureRecognizer(target: self, action: #selector(onTapForget(_:)))
        
        registerLabel.attributedText = UILabel.buildAttributtedString(with: [
            Attr(text: "Don't have an account? ", size: 16, weight: .regular, color: Color.label),
            Attr(text: "Sign Up", size: 16, weight: .medium, color: Color.primary)
        ])
        let tapRegister = UITapGestureRecognizer(target: self, action: #selector(onTapRegister(_:)))
        
        forgetLabel.addGestureRecognizer(tapForget)
        loginButton.addTarget(self, action: #selector(onTapLogin(_:)), for: .touchUpInside)
        registerLabel.addGestureRecognizer(tapRegister)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
    }
    
    @objc
    private func onTapForget(_ sender: UITapGestureRecognizer) {
        let viewController = ForgetPasswordController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func onTapLogin(_ sender: UIButton) {
        login()
    }
    
    private func login() {
        [
            emailText,
            passText
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
        
        viewModel.login { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    UIApplication.currentUIWindow()?.rootViewController = MainController()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
    
    @objc
    private func onTapRegister(_ sender: UITapGestureRecognizer) {
        navigationController?.setViewControllers([RegisterController()], animated: true)
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailText:
            passText.becomeFirstResponder()
        case passText:
            textField.resignFirstResponder()
            self.login()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
