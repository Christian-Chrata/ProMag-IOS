//
//  UIViewController+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit
import Networking
import AuthManager
import Common

enum AlertStat {
    case success
    case failure
    case warning
    
    var title: String {
        switch self {
        case .success:
            return "Berhasil!"
        case .failure:
            return "Oooops..."
        case .warning:
            return "Mohon Menunggu"
        }
    }
}


public extension UIViewController {
    
    func show(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .cancel, handler: { (_) in
            completion?()
        }))
        alert.present(animated: true, completion: nil)
    }
    
    func show(with error: NetworkError, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            switch error {
            case .authenticationError:
                CustomFunction.shared.removeKeychain()
                let alert = AlertController(with: .failure(message: "Sesi berakhir, silahkan login kembali"))
                alert.addAction(AlertAction(title: "Oke", type: .primary, completion: {
                    UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: LoginController())
                }))
                alert.show()
            case .softError(let message):
                let alert = AlertController(with: .failure(message: message))
                alert.addAction(AlertAction(title: "Oke", type: .primary, completion: nil))
                alert.show()
            default:
                let alert = AlertController(with: .failure(message: error.description))
                alert.addAction(AlertAction(title: "BATAL", type: .primary, completion: {
                    completion?()
                }))
                alert.show()
            }
        }
    }
}
