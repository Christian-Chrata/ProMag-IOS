//
//  EditProfileController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 27/04/23.
//

import UIKit
import Common
import Networking

class EditProfileController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fName: TextField!
    @IBOutlet weak var lName: TextField!
    @IBOutlet weak var pNumber: TextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var viewModel = EditProfileViewModel()
    
    init() {
        super.init(nibName: "EditProfileController", bundle: Bundle(for: EditProfileController.self))
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
            fName,
            lName,
            pNumber
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
        
        title = "Edit Profile"
    }
    
    @objc func onTapSubmit(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        [
            fName,
            lName,
            pNumber
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
        
        if viewModel.checkUser() {
            viewModel.saveUser { (state) in
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
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension EditProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fName:
            lName.becomeFirstResponder()
        case lName:
            pNumber.becomeFirstResponder()
        case pNumber:
            textField.resignFirstResponder()
            submit()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
