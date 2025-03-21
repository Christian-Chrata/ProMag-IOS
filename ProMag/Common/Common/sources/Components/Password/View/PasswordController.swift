//
//  PasswordController.swift
//  Common
//
//  Created by Christian Wiradinata on 03/05/23.
//

import UIKit
import Networking

public protocol PasswordControllerDelegate {
    func submit(with password: String)
}

public class PasswordController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordText: TextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var viewModel = PasswordViewModel()
    public var delegate: PasswordControllerDelegate?

    public init() {
        super.init(nibName: "PasswordController", bundle: Bundle(identifier: "com.chrata.Common"))
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordText.delegate = self
        passwordText.isEnabled = self.viewModel.textFields[0].enabled
        passwordText.type = self.viewModel.textFields[0].type
        passwordText.isRequired = self.viewModel.textFields[0].isRequired
        passwordText.placeholder = self.viewModel.textFields[0].placeholder
        passwordText.text = self.viewModel.textFields[0].value
        passwordText.setup()
        
        confirmButton.addTarget(self, action: #selector(onTapConfirm(_:)), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(onTapDismiss(_:)), for: .touchUpInside)
        
        confirmButton.addTarget(self, action: #selector(onTapConfirm(_:)), for: .touchUpInside)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
        
        passwordText.becomeFirstResponder()
    }
    
    @objc
    private func onTapDismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc
    private func onTapConfirm(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        guard let text = passwordText.text else { return }
        self.viewModel.textFields[0].value = text
        passwordText.validate()
        passwordText.resignFirstResponder()
        
        guard CustomFunction.shared.validate(with: viewModel.textFields) else {
            let alert = AlertController(with: .warning(message: CustomFunction.shared.getError()))
            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: nil))
            alert.show()
            return
        }
        
        guard let delegate = delegate else { return }
        delegate.submit(with: viewModel.getPassword())
    }
}

extension PasswordController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewConstraint.constant = 32
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewConstraint.constant = 139
    }
}
