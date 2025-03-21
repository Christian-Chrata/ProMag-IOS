//
//  ForgetPasswordController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 29/01/23.
//

import UIKit
import Common

class ForgetPasswordController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailText: TextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var viewModel = ForgetPasswordViewModel()
    
    init() {
        super.init(nibName: "ForgetPasswordController", bundle: Bundle(for: ForgetPasswordController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [
            emailText
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
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        submitButton.addTarget(self, action: #selector(onTapSubmit(_:)), for: .touchUpInside)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
    }
    
    @objc func onTapSubmit(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        [
            emailText
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
        
        viewModel.forgetPassword { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    let alert = AlertController(with: .success(title: "Email has been sent!", message: "Please check your inbox and click in the received link to reset a password"))
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

extension ForgetPasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailText:
            textField.resignFirstResponder()
            submit()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
