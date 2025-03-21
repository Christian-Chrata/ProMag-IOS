//
//  MyProfileController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 28/01/23.
//

import UIKit
import Common

class MyProfileController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userFirstLetter: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newTeamButton: UIButton!
    @IBOutlet weak var manageAccountButton: UIButton!
    @IBOutlet weak var versionButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!

    private var viewModel = MyProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userButton.addTarget(self, action: #selector(onTapEditUser(_:)), for: .touchUpInside)
        newTeamButton.addTarget(self, action: #selector(onTapNewTeam(_:)), for: .touchUpInside)
        manageAccountButton.addTarget(self, action: #selector(onTapManageAccount(_:)), for: .touchUpInside)
        versionButton.addTarget(self, action: #selector(onTapVersion(_:)), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(onTapLogout(_:)), for: .touchUpInside)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TeamListCell", bundle: Bundle(for: TeamListCell.self)), forCellReuseIdentifier: "TeamListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    private func setup() {
        navigationItem.title = viewModel.getCurrentTeam()
        
        userFirstLetter.text = viewModel.getUserFirstLetter()
        userName.text = viewModel.getUserName()
        userEmail.text = viewModel.getUserEmail()
        
        self.tableViewHeight.constant = self.viewModel.getTableViewHeight()
        
        viewModel.getUserData { (state) in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    
                    self.navigationItem.title = self.viewModel.getCurrentTeam()
                    
                    self.userFirstLetter.text = self.viewModel.getUserFirstLetter()
                    self.userName.text = self.viewModel.getUserName()
                    self.userEmail.text = self.viewModel.getUserEmail()
                    
                    self.tableViewHeight.constant = self.viewModel.getTableViewHeight()
                    self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 521 + self.viewModel.getTableViewHeight())
                    
                    self.tableView.reloadData()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self.show(with: error)
                }
            }
        }
    }
    
    @objc func onTapEditUser(_ sender: UIButton) {
        let viewController = EditProfileController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func onTapNewTeam(_ sender: UIButton) {
        let viewController = ProfileTeamController(with: .create)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func onTapManageAccount(_ sender: UIButton) {
        let viewController = ManageAccountController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func onTapVersion(_ sender: UIButton) {
        print("Go to version")
    }
    
    @objc func onTapLogout(_ sender: UIButton) {
        let alert = AlertController(with: .warning(message: "Are you sure want to sign out?"))
        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
            CustomFunction.shared.removeKeychain()
            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: LoginController())
        }))
        alert.addAction(AlertAction(title: "NEVERMIND", type: .secondary, completion: nil))
        alert.show()
    }
}

extension MyProfileController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as? TeamListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setup(with: viewModel.getTeamForRowAt(row: indexPath.row), row: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTeamCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.checkSelectedTeam(with: indexPath.row) {
            let alert = AlertController(with: .warning(message: "Are you sure about changing your selected team?"))
            alert.addAction(AlertAction(title: "YES", type: .primary, completion: {
                self.viewModel.selectTeam(with: indexPath.row)
                self.setup()
            }))
            alert.addAction(AlertAction(title: "NEVERMIND", type: .secondary, completion: nil))
            alert.show()
        }
    }
}

extension MyProfileController: TeamListCellDelegate {
    func tapDetail(row: Int) {
        let team = viewModel.getTeamForRowAt(row: row)
        let viewController = ProfileTeamController(with: .edit(id: team.id, title: team.name, description: team.desc))
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
