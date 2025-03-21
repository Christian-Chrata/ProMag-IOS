//
//  SelectTeamController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 20/05/23.
//

import UIKit
import Common

protocol SelectTeamControllerDelegate {
    func selectTeam(id: String, name: String)
}

class SelectTeamController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var viewModel = SelectTeamViewModel()
    private var state: SelectTeamState = .single
    
    var delegate: SelectTeamControllerDelegate?
    
    init(state: SelectTeamState, viewModel: SelectTeamViewModel) {
        super.init(nibName: "SelectTeamController", bundle: Bundle(identifier: "com.chrata.promag"))
        
        self.state = state
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch state {
        case .single:
            tableView.register(UINib(nibName: "SingleSelectTeamCell", bundle: Bundle(for: SingleSelectTeamCell.self)), forCellReuseIdentifier: "SingleSelectTeamCell")
        case .multiple:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(onTapAdd(_:)))
            tableView.register(UINib(nibName: "MultipleSelectTeamCell", bundle: Bundle(for: MultipleSelectTeamCell.self)), forCellReuseIdentifier: "MultipleSelectTeamCell")
        }
                                                                
        navigationController?.navigationBar.tintColor = Color.primary
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshData()
    }

    private func refreshData() {
        switch state {
        case .single:
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
        case .multiple:
            viewModel.getMultipleProjectTeamData { (state) in
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
    }
    
    @objc func onTapAdd(_ sender: UIButton) {
        viewModel.insertUser { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success(let message):
                    LoadingController.shared.dismiss()
                    if message != "" {
                        let alert = AlertController(with: .success(message: message))
                        alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                            self?.navigationController?.popViewController(animated: true)
                        }))
                        alert.show()
                    } else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error, completion: nil)
                }
            }
        }
    }
}

extension SelectTeamController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .single:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectTeamCell", for: indexPath) as? SingleSelectTeamCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setup(with: viewModel.getTeamForRow(row: indexPath.row))
            return cell
        case .multiple:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSelectTeamCell", for: indexPath) as? MultipleSelectTeamCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setup(with: viewModel.getTeamForRow(row: indexPath.row))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTeamsCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
        case .single:
            guard let delegate = self.delegate else { return }
            self.dismiss(animated: true, completion: {
                let member = self.viewModel.getTeamForRow(row: indexPath.row)
                delegate.selectTeam(id: member.userId, name: "\(member.firstName) \(member.lastName)")
            })
        case .multiple:
            if !viewModel.getTeamIsJoin(with: indexPath.row) {
                self.viewModel.selectMultipleMember(with: indexPath.row)
                tableView.reloadData()
            }
        }
    }
}

extension SelectTeamController: MemberDetailControllerDelegate {
    func onDismiss() {
        refreshData()
    }
}
