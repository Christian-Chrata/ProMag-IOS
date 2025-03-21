//
//  UIViewController+Extension.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public extension UIViewController {
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.compactMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.flatMap({$0})
    }
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    func show(completion: (()->Void)? = nil) {
        present(animated: true, completion: completion)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        present(with: root, animated: animated, completion: completion)
    }
    
    private func present(with viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if viewController.isModal,
           let presentedViewController = viewController.presentedViewController {
            present(with: presentedViewController, animated: true, completion: completion)
        } else {
            if let navigationController = viewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
                guard let presentedViewController = visibleViewController.presentedViewController else {
                    present(with: visibleViewController, animated: animated, completion: completion)
                    return
                }
                present(with: presentedViewController, animated: animated, completion: completion)
            } else if let tabBarController = viewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
                present(with: selectedViewController, animated: animated, completion: completion)
            } else {
                viewController.present(self, animated: true, completion: completion)
            }
        }
    }
}
