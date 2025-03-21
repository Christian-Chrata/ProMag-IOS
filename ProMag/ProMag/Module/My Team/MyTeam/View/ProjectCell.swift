//
//  MyTeamCell.swift
//  ProMag
//
//  Created by Christian Wiradinata on 08/05/23.
//

import UIKit
import Common

class ProjectCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(with team: ProjectModel) {
        titleLabel.text = team.projectName
        
        let initial = team.pmName
        initialLabel.text = initial[initial.startIndex].uppercased()
        
        nameLabel.text = team.pmName
        
        dateLabel.text = team.projectEnddate
        
        statusLabel.text = team.status
    }
}
