//
//  ProjectDashboardController.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/05/23.
//

import UIKit
import Common

class ProjectDashboardController: UIViewController {
    
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    
    var viewModel = ProjectDashboardViewModel()
    
    init(viewModel: ProjectDashboardViewModel) {
        super.init(nibName: "ProjectDashboardController", bundle: Bundle(for: ProjectDashboardController.self))
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getDashboardData { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .loading:
                    LoadingController.shared.show()
                case .success:
                    LoadingController.shared.dismiss()
                    self?.setup()
                case .error(let error):
                    LoadingController.shared.dismiss()
                    self?.show(with: error)
                }
            }
        }
    }
    
    private func setup() {
        completedLabel.attributedText = UILabel.buildAttributtedString(with: [
            Attr(text: viewModel.getTaskCompleted(), size: 40, weight: .regular, color: Color.primary),
            Attr(text: " Task(s)", size: 22, weight: .regular, color: Color.label)
        ])
        
        if viewModel.getPercentage() == "-1" {
            percentageLabel.attributedText = UILabel.buildAttributtedString(with: [
                Attr(text: "-", size: 40, weight: .regular, color: Color.primary)
            ])
        } else {
            percentageLabel.attributedText = UILabel.buildAttributtedString(with: [
                Attr(text: viewModel.getPercentage(), size: 40, weight: .regular, color: Color.primary),
                Attr(text: "%", size: 22, weight: .regular, color: Color.label)
            ])
        }
        
        
        taskLabel.attributedText = UILabel.buildAttributtedString(with: [
            Attr(text: viewModel.getTotalTasks(), size: 40, weight: .regular, color: Color.primary),
            Attr(text: " Task(s)", size: 22, weight: .regular, color: Color.label)
        ])
        
        memberLabel.attributedText = UILabel.buildAttributtedString(with: [
            Attr(text: viewModel.getTotalMember(), size: 40, weight: .regular, color: Color.primary),
            Attr(text: " Member(s)", size: 22, weight: .regular, color: Color.label)
        ])
    }
}
