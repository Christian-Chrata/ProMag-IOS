//
//  MultipleSelectTeamCell.swift
//  ProMag
//
//  Created by Christian Wiradinata on 20/05/23.
//

import UIKit
import Common

class MultipleSelectTeamCell: UITableViewCell {
    
    @IBOutlet weak var initialView: UIView!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setup(with team: TeamMemberModel) {
        if team.isJoined {
            initialView.backgroundColor = UIColor.gray
            nameLabel.textColor = UIColor.gray
            checkButton.tintColor = UIColor.gray
        }
        
        let initial = team.firstName
        initialLabel.text = initial[initial.startIndex].uppercased()
        
        nameLabel.text = "\(team.firstName) \(team.lastName)"
        
        if team.isChecked {
            checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
}
