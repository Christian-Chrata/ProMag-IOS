//
//  TaskCell.swift
//  ProMag
//
//  Created by Christian Wiradinata on 23/05/23.
//

import UIKit
import Common

class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with task: TaskModel) {
        titleLabel.text = task.title
        
        let end = task.endDate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")?.toString(dateFormat: "dd MMMM YYYY")
        dateLabel.text = end
        
        projectLabel.text = task.projectName
        
        switch task.status.lowercased() {
        case "unfinished", "due": statusLabel.textColor = Color.danger
        case "finished": statusLabel.textColor = Color.primary
        default: statusLabel.textColor = UIColor.label
        }
        
        statusLabel.text = task.status
    }
}
