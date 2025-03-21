//
//  ProjectMemberController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/05/23.
//

import UIKit
import Common

class ProjectMemberController: UIViewController {
    
    @IBOutlet weak var searchText: TextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var viewModel = ProjectMemberViewModel(projectId: "")
    
    init(viewModel: ProjectMemberViewModel) {
        super.init(nibName: "ProjectMemberController", bundle: Bundle(for: ProjectMemberController.self))
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.addTarget(self, action: #selector(onTapInviteMember(_:)), for: .touchUpInside)
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TeamMemberCell", bundle: Bundle(for: TeamMemberCell.self)), forCellReuseIdentifier: "TeamMemberCell")
        
        searchText.addTarget(self, action: #selector(didSearch(_:)), for: .allEvents)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        
        [
            searchText
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
    }
    
    private func refreshData() {
        viewModel.getMemberData() { (state) in
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
        if viewModel.isAllowedToInvite() { // Cuma Project Manager yang boleh invite
            let selViewModel = SelectTeamViewModel(projectId: viewModel.getProjectId())
            let viewController = SelectTeamController(state: .multiple, viewModel: selViewModel)
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let alert = AlertController(with: .warning(message: "You need to be Project Manager to invite people to this project"))
            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: nil))
            alert.show()
        }
    }
    
    @objc private func didSearch(_ sender: UITextField) {
        guard let text = sender.text else {return}
        searchMember(with: text)
    }
    
    private func searchMember(with text: String) {
        viewModel.searchMember(with: text)
        tableView.reloadData()
    }
}

extension ProjectMemberController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell", for: indexPath) as? TeamMemberCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setup(with: viewModel.getMemberForRowAt(with: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMembersCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = viewModel.getMemberForRowAt(with: indexPath.row)
        let viewModel = MemberDetailViewModel(member: member, userRoleId: viewModel.getUserRole(), projectId: viewModel.getProjectId())
        let viewController = MemberDetailController(with: viewModel, page: .projectDetail)
        viewController.delegate = self
        navigationController?.present(viewController, animated: true)
    }
}

extension ProjectMemberController: MemberDetailControllerDelegate {
    func onDismiss() {
        refreshData()
    }
}

extension ProjectMemberController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchText:
            textField.resignFirstResponder()
            searchMember(with: textField.text ?? "")
        default:
            textField.resignFirstResponder()
            searchMember(with: textField.text ?? "")
        }
        return true
    }
}
