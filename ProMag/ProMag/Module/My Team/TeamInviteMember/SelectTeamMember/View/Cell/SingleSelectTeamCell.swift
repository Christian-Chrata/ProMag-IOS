//
//  SingleSelectTeamCell.swift
//  ProMag
//
//  Created by Christian Wiradinata on 20/05/23.
//

import UIKit

class SingleSelectTeamCell: UITableViewCell {

    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with team: TeamMemberModel) {
        
        let initial = team.firstName
        initialLabel.text = initial[initial.startIndex].uppercased()
        
        nameLabel.text = "\(team.firstName) \(team.lastName)"
    }
}
