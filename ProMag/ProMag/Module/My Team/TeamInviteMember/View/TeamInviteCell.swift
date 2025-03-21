//
//  TeamInviteCell.swift
//  ProMag
//
//  Created by Christian Wiradinata on 15/05/23.
//

import UIKit

class TeamInviteCell: UITableViewCell {

    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func setup(with target: TeamMemberModel) {
        let firstName = target.firstName
        initialLabel.text = firstName[firstName.startIndex].uppercased()
        nameLabel.text = "\(firstName) \(target.lastName)"
    }
}
