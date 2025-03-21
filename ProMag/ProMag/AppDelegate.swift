//
//  AppDelegate.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit
import Networking
import Common
import AuthManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = Color.white
        
//        CustomFunction.shared.removeKeychain()
        
        if !CustomFunction.shared.getKeychain(with: .accessToken).isEmpty {
            let viewController: UIViewController = MainController()
            window?.rootViewController = viewController
        } else {
            let viewController: UIViewController = LoginController()
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        func applicationWillEnterForeground(_ application: UIApplication) {
            
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme,
           scheme.localizedCaseInsensitiveCompare("com.chrata.promag") == .orderedSame,
           let view = url.host {
            
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            redirect(to: view, parameters: parameters)
        }
        return true
    }
    
    func redirect(to: String, parameters: [String:String]) {
        switch to {
        case "forget":
            
            if CustomFunction.shared.getKeychain(with: .accessToken).isEmpty {
                var email = ""
                var token = ""
                for param in parameters {
                    switch param.key{
                    case "email":
                        email = param.value
                    case "token":
                        token = param.value
                    default:
                        break
                    }
                }
                
                
                let viewController: UIViewController = LoginController()
                let navigationController = UINavigationController(rootViewController: viewController)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    let viewModel = ConfrmForgetPasswordViewModel(email: email, token: token)
                    navigationController.pushViewController(ConfirmForgetPasswordController(with: viewModel), animated: true)
                }
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
            }
        default:
            break
        }
    }
    
}

