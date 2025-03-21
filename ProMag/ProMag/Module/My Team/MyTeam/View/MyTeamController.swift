//
//  MyTeamController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 28/01/23.
//

import UIKit
import Foundation
import Common

class MyTeamController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addButton: UIButton!

    private var viewModel = MyTeamViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.addTarget(self, action: #selector(onTapAddProject(_:)), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "ProjectCell", bundle: Bundle(for: ProjectCell.self)), forCellReuseIdentifier: "ProjectCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = viewModel.getCurrentTeam()
        
        if viewModel.isShowMember() {
            let member = UIBarButtonItem(image: UIImage(systemName: "person.3.fill"), style: .plain, target: self, action: #selector(onTapMember(_:)))
            member.tintColor = Color.primary
            navigationItem.rightBarButtonItems = [member]
        }
        
        viewModel.getTeamInfo { (state) in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    self.addView.isHidden = self.viewModel.isHideAddProject()
                    LoadingController.shared.dismiss()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self.show(with: error)
                }
            }
        }
        
        viewModel.getProjectData { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    self?.tableView.reloadData()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
    
    @objc func onTapAddProject(_ sender: UIButton) {
        let viewController = CreateProjectController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func onTapMember(_ sender: UIBarButtonItem) {
        let viewController = TeamMemberController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MyTeamController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setup(with: viewModel.getProjectForRowAt(row: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getProjectCount() == 0 {
            tableView.setEmptyView(title: "You don’t have any Project", message: "If you are the owner or manager of this team you can create projects by clicking the button bellow")
        } else {
            tableView.restore()
        }
        return viewModel.getProjectCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = viewModel.getProjectForRowAt(row: indexPath.row)

        let viewController = DetailProjectNavigationController(projectId: team.projectId, title: team.projectName, role: viewModel.getRoleId())
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
}
