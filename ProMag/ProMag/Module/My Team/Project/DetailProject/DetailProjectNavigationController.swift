//
//  DetailProjectNavigationController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 22/05/23.
//

import UIKit
import AuthManager
import Networking
import Common
import Foundation

class EmptyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(onTapBack(_:)))
        navigationController?.navigationBar.configure(with: .solid(color: .white))
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        view.backgroundColor = .white
    }
    
    @objc
    private func onTapBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

public class DetailProjectNavigationController: UINavigationController {
    private var name: String = ""
    private var roleId: String = ""
    private var projectId: String = ""
    private let viewModel: AvtivityViewModel = AvtivityViewModel()
    
    public init(projectId: String, title: String, role: String) {
        super.init(nibName: nil, bundle: nil)
        self.projectId = projectId
        self.name = title
        self.roleId = role
        
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .coverVertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        view.backgroundColor = .white
        setViewControllers([EmptyViewController()], animated: true)
        
        self.handleStep()
    }
    
    private func handleStep() {
        let taskViewModel = ProjectTaskViewModel(projectId: self.projectId)
        let memberViewModel = ProjectMemberViewModel(projectId: self.projectId)
        let dashboardViewModel = ProjectDashboardViewModel(projectId: self.projectId)
        
        let task = ProjectTaskController(viewModel: taskViewModel)
        
        let member = ProjectMemberController(viewModel: memberViewModel)
        
        let dashboard = ProjectDashboardController(viewModel: dashboardViewModel)
        
        switch roleId {
        case "1", "2", "3": // Owner, Manager, Project Manager
            let pages = [
                PageTab(title: "Task", viewController: task),
                PageTab(title: "Member", viewController: member),
                PageTab(title: "Dashboard", viewController: dashboard)
            ]
            let viewController = ActivityController(with: name, pages: pages, tabType: .blue)
            self.setViewControllers([viewController], animated: true)
        default: // Sisanya (Developer, Member)
            let pages = [
                PageTab(title: "Task", viewController: task),
                PageTab(title: "Member", viewController: member)
            ]
            let viewController = ActivityController(with: name, pages: pages, tabType: .blue)
            self.setViewControllers([viewController], animated: true)
        }
    }
}
