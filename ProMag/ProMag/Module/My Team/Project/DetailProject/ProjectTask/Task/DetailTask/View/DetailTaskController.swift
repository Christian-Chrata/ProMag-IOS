//
//  DetailTaskController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 05/06/23.
//

import UIKit
import Common

class DetailTaskController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var finishedView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var assignLbl: UILabel!
    @IBOutlet weak var dueLbl: UILabel!
    @IBOutlet weak var projectLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var subtaskTableView: UITableView!
    @IBOutlet weak var subTaskHeight: NSLayoutConstraint!
    @IBOutlet weak var addSubButton: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    @IBOutlet weak var commentField: TextField!
    @IBOutlet weak var commentBottom: NSLayoutConstraint!
    @IBOutlet weak var commentButton: UIButton!
    
    private var viewModel = DetailTaskViewModel(taskId: "")
    
    init(viewModel: DetailTaskViewModel) {
        super.init(nibName: "DetailTaskController", bundle: Bundle(for: DetailTaskController.self))
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Color.primary
        
        addSubButton.addTarget(self, action: #selector(onTapAddSubTask(_:)), for: .touchUpInside)
        
        setKeyboard()
        
        let completeButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(onTapComplete(_:)))
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(onTapMenu(_:)))
        
        commentButton.addTarget(self, action: #selector(onTapComment(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [menuButton, completeButton]
        
        [
            subtaskTableView,
            commentTableView
        ]
            .enumerated()
            .forEach { (offset, tableView) in
                tableView?.delegate = self
                tableView?.dataSource = self
                tableView?.register(UINib(nibName: "SubtaskCell", bundle: Bundle(for: SubtaskCell.self)), forCellReuseIdentifier: "SubtaskCell")
                tableView?.register(UINib(nibName: "CommentCell", bundle: Bundle(for: CommentCell.self)), forCellReuseIdentifier: "CommentCell")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [
            commentField
        ]
            .enumerated()
            .forEach { (offset, textField) in
                textField?.type = self.viewModel.textFields[offset].type
                textField?.isRequired = self.viewModel.textFields[offset].isRequired
                textField?.isEnabled = self.viewModel.textFields[offset].enabled
                textField?.placeholder = self.viewModel.textFields[offset].placeholder
                textField?.text = self.viewModel.textFields[offset].value
                textField?.borderStyle = .bezel
                textField?.setup()
        }
        
        reset()
    }
    
    private func setKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let scrollView = scrollView else { return }
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - keyboardSize.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
        commentBottom.constant += keyboardSize.height
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        commentBottom.constant = 0
    }
    
    private func reset() {
        viewModel.getTaskDetail { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    self?.titleLbl.text = self?.viewModel.getTaskName()
                    self?.assignLbl.text = self?.viewModel.getTaskAssignTo()
                    self?.dueLbl.text = self?.viewModel.getTaskDue()
                    self?.projectLbl.text = self?.viewModel.getTaskProjectName()
                    self?.descLbl.text = self?.viewModel.getTaskDesc()
                    self?.finishedView.isHidden = self?.viewModel.checkTaskStatus() ?? false
                    self?.commentField.text = ""
                    self?.subtaskTableView.reloadData()
                    self?.commentTableView.reloadData()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error, completion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    private func submitComment() {
        [
            commentField
        ].enumerated().forEach{ (offset, textField) in
            guard let value = textField?.value() else { return }
            self.viewModel.textFields[offset].value = value
            textField?.validate()
            textField?.resignFirstResponder()
        }
        
        guard CustomFunction.shared.validate(with: viewModel.textFields) else {
            let alert = AlertController(with: .warning(message: CustomFunction.shared.getError()))
            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: nil))
            alert.show()
            return
        }
        
        viewModel.postComment { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    self?.reset()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
    
    @objc func onTapMenu(_ sender: UIButton) {
        let menu = MenuController()
        menu.addAction(MenuAction(title: "EDIT TASK", type: .primary, completion: {
            let taskViewModel = CreateTaskViewModel(roleId: self.viewModel.getUserRoleId())
            taskViewModel.textFields[0].value = self.viewModel.getTaskName()
            taskViewModel.textFields[1].value = self.viewModel.getTaskDesc()
            taskViewModel.textFields[2].value = self.viewModel.getTaskAssignTo()
            taskViewModel.textFields[3].value = self.viewModel.getTaskDue()
            taskViewModel.assignToRoleId = self.viewModel.getAssignedId()
            let viewController = CreateTaskController(viewModel: taskViewModel, state: .edit(taskId: self.viewModel.getTaskId()))
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        menu.addAction(MenuAction(title: "DELETE TASK", type: .danger, completion: {
            let alert = AlertController(with: .warning(message: "Are you sure your want to delete “\(self.viewModel.getTaskName())” task?"))
            alert.addAction(AlertAction(title: "DELETE", type: .danger, completion: {
                self.viewModel.deleteTask { (state) in
                    DispatchQueue.main.async { [weak self] in
                        switch state {
                        case .loading:
                            LoadingController.shared.show()
                        case .success(let message):
                            LoadingController.shared.dismiss()
                            let alert = AlertController(with: .success(message: message))
                            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                                self?.navigationController?.popViewController(animated: true)
                            }))
                            alert.show()
                        case .error(let error):
                            LoadingController.shared.dismiss()
                            self?.show(with: error)
                        }
                    }
                }
            }))
            alert.addAction(AlertAction(title: "NEVERMIND", type: .secondary, completion: nil))
            alert.show()
        }))
        
        menu.addAction(MenuAction(title: "CANCEL", type: .secondary, completion: nil))
        menu.show()
    }
    
    @objc func onTapComplete(_ sender: UIButton) {
        viewModel.completeTask { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    self?.reset()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
    
    @objc func onTapAddSubTask(_ sender: UIButton) {
        let taskViewModel = CreateSubtaskViewModel(roleId: self.viewModel.getUserRoleId())
        let viewController = CreateSubtaskController(viewModel: taskViewModel, state: .create(taskId: self.viewModel.getTaskId()))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func onTapComment(_ sender: UIButton) {
        if commentField.text != "" {
            submitComment()
            commentField.resignFirstResponder()
        }
    }
}

extension DetailTaskController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case subtaskTableView:
            subTaskHeight.constant = viewModel.getSubtaskTableHeight()
            return viewModel.getSubtaskCount()
        case commentTableView:
            commentHeight.constant = viewModel.getCommentTableHeight()
            return viewModel.getCommentCount()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case subtaskTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubtaskCell", for: indexPath) as? SubtaskCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setup(with: viewModel.getSubtaskForRowAt(with: indexPath.row).title)
            return cell
        case commentTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setup(with: viewModel.getCommentForRowAt(with: indexPath.row))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case subtaskTableView: return 50
        case commentTableView: return 140
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case subtaskTableView:
            let taskViewModel = DetailTaskViewModel(taskId: viewModel.getSubtaskForRowAt(with: indexPath.row).id)
            let viewController = DetailTaskController(viewModel: taskViewModel)
            self.navigationController?.pushViewController(viewController, animated: true)
        case commentTableView:
            let menu = MenuController()
            menu.addAction(MenuAction(title: "DELETE COMMENT", type: .danger, completion: {
                self.viewModel.deleteComment(with: indexPath.row) { (state) in
                    DispatchQueue.main.async { [weak self] in
                        switch state {
                        case .loading:
                            LoadingController.shared.show()
                        case .success(let message):
                            LoadingController.shared.dismiss()
                            let alert = AlertController(with: .success(message: message))
                            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: {
                                self?.reset()
                            }))
                            alert.show()
                        case .error(let error):
                            LoadingController.shared.dismiss()
                            self?.show(with: error)
                        }
                    }
                }
            }))
            
            menu.addAction(MenuAction(title: "CANCEL", type: .secondary, completion: nil))
            menu.show()
        default: break
        }
    }
}
