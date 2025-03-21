//
//  MainController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 28/01/23.
//

import UIKit
import Common
import Networking
import AuthManager
import SwiftUI

class MainController: UITabBarController {
    
    private var isNoConnection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let task = UINavigationController(rootViewController: MyTaskController())
        task.tabBarItem.image = UIImage(named: "mytask")
        task.tabBarItem.title = "My Task"
        
        let team = UINavigationController(rootViewController: MyTeamController())
        team.tabBarItem.image = UIImage(named: "myteam")
        team.tabBarItem.title = "My Team"
        
        let profile = UINavigationController(rootViewController: MyProfileController())
        profile.tabBarItem.image = UIImage(named: "myprofile")
        profile.tabBarItem.title = "My Profile"
        
        tabBar.tintColor = Color.primary
        
        tabBar.isTranslucent = false
        
        let tabGradientView = UIView(frame: tabBar.bounds)
        tabGradientView.backgroundColor = UIColor.white
        tabGradientView.translatesAutoresizingMaskIntoConstraints = false;
        
        
        tabBar.addSubview(tabGradientView)
        tabBar.sendSubviewToBack(tabGradientView)
        tabGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setViewControllers([task, team, profile], animated: true)
    }
    
    @objc private func swipeGesture(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case .right:
            if selectedIndex > 0 {
                self.selectedIndex = self.selectedIndex - 1
            }
            break
        case .left:
            if selectedIndex < 4 {
                self.selectedIndex = self.selectedIndex + 1
            }
            break
        default: break
        }
    }
}
