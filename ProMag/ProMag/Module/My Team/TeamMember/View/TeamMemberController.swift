//
//  TeamMemberController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 11/05/23.
//

import UIKit
import Common

class TeamMemberController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addButton: UIButton!

    private var viewModel = TeamMemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.addTarget(self, action: #selector(onTapInviteMember(_:)), for: .touchUpInside)
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TeamMemberCell", bundle: Bundle(for: TeamMemberCell.self)), forCellReuseIdentifier: "TeamMemberCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addView.isHidden = viewModel.isHideInvite()
        
        refreshData()
    }
    
    private func refreshData() {
        viewModel.getTeamsData() { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    self?.tableView.reloadData()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error, completion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    @objc func onTapInviteMember(_ sender: UIButton) {
        let viewController = TeamInviteController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TeamMemberController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell", for: indexPath) as? TeamMemberCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setup(with: viewModel.getTeamForRow(row: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTeamsCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = viewModel.getTeamForRow(row: indexPath.row)
        let viewModel = MemberDetailViewModel(member: member, userRoleId: viewModel.getUserRole())
        let viewController = MemberDetailController(with: viewModel, page: .teamDetail)
        viewController.delegate = self
        navigationController?.present(viewController, animated: true)
    }
}

extension TeamMemberController: MemberDetailControllerDelegate {
    func onDismiss() {
        refreshData()
    }
}
