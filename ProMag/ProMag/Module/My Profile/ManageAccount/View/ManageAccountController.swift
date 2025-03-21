//
//  ManageAccountController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 29/04/23.
//

import UIKit
import Common
import Networking

class ManageAccountController: UIViewController {
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var viewModel = ManageAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailButton.addTarget(self, action: #selector(onTapEmail(_:)), for: .touchUpInside)
        passwordButton.addTarget(self, action: #selector(onTapPassword(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(onTapDelete(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        title = "Manage Account"
    }
    
    @objc func onTapEmail(_ sender: UIButton) {
        let viewController = ChangeEmailController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func onTapPassword(_ sender: UIButton) {
        let viewController = ChangePasswordController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func onTapDelete(_ sender: UIButton) {
        let alert = AlertController(with: .warning(message: "We need a sent OTP to your email for confirmation. Do you want to proceed?"))
        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
            let password = PasswordController()
            password.delegate = self
            password.show()
        }))
        alert.addAction(AlertAction(title: "NEVERMIND", type: .secondary, completion: nil))
        alert.show()
    }

}

extension ManageAccountController: PasswordControllerDelegate {
    func submit(with password: String) {
        self.viewModel.deleteAccount(password: password) { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success(let message):
                    LoadingController.shared.dismiss()
                    self?.dismiss(animated: true, completion: {
                        let alert = AlertController(with: .success(message: message))
                        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: LoginController())
                        }))
                        alert.show()
                    })
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
}
