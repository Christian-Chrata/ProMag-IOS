//
//  MyTaskController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 28/01/23.
//

import UIKit
import Common

class MyTaskController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var viewModel = MyTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TaskCell", bundle: Bundle(for: TaskCell.self)), forCellReuseIdentifier: "TaskCell")
        
        let filter = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"), style: .plain, target: self, action: #selector(onTapSorting(_:)))
        filter.tintColor = Color.primary
        navigationItem.rightBarButtonItems = [filter]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = viewModel.getCurrentTeam()
        
        viewModel.getTaskData { (state) in
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
    
    @objc func onTapSorting(_ sender: UIBarButtonItem) {
        viewModel.sortingTask(with: viewModel.getTaskState())
        tableView.reloadData()
    }
}

extension MyTaskController: UITableViewDataSource, UITableViewDelegate {
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
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
