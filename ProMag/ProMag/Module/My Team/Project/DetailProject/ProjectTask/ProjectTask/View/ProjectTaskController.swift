//
//  ProjectTaskController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 21/05/23.
//

import UIKit
import Common

class ProjectTaskController: UIViewController {
    
    @IBOutlet weak var searchText: TextField!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ProjectTaskViewModel()
    
    init(viewModel: ProjectTaskViewModel) {
        super.init(nibName: "ProjectTaskController", bundle: Bundle(for: ProjectTaskController.self))
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortButton.addTarget(self, action: #selector(onTapSort(_:)), for: .touchUpInside)
        
        addButton.addTarget(self, action: #selector(onTapAddTask(_:)), for: .touchUpInside)
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TaskCell", bundle: Bundle(for: TaskCell.self)), forCellReuseIdentifier: "TaskCell")
        
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
        viewModel.getTask() { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    self?.tableView.reloadData()
                    self?.addView.isHidden = !(self?.viewModel.isAllowedToAdd() ?? true)
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error, completion: {
                        self?.dismiss(animated: true)
                    })
                }
            }
        }
    }
    
    @objc func onTapSort(_ sender: UIButton) {
        viewModel.sortingTask(with: viewModel.getTaskState())
        tableView.reloadData()
    }
    
    @objc func onTapAddTask(_ sender: UIButton) {
        let taskViewModel = CreateTaskViewModel(roleId: viewModel.getUserRole())
        let viewController = CreateTaskController(viewModel: taskViewModel, state: .create(projectId: viewModel.getProjectId()))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func didSearch(_ sender: UITextField) {
        guard let text = sender.text else {return}
        searchTask(with: text)
    }
    
    private func searchTask(with text: String) {
        viewModel.searchTask(with: text)
        tableView.reloadData()
    }
}

extension ProjectTaskController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setup(with: viewModel.getTaskForRowAt(with: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getTaskCount() == 0 {
            tableView.setEmptyView(title: "You don’t have any task", message: "Either you completed all the task assigned to you or your project manager hate you")
        } else {
            tableView.restore()
        }
        return viewModel.getTaskCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.getTaskForRowAt(with: indexPath.row)
        
        let detailViewModel = DetailTaskViewModel(taskId: task.id)

        let viewController = DetailTaskController(viewModel: detailViewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ProjectTaskController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchText:
            textField.resignFirstResponder()
            searchTask(with: textField.text ?? "")
        default:
            textField.resignFirstResponder()
            searchTask(with: textField.text ?? "")
        }
        return true
    }
}
