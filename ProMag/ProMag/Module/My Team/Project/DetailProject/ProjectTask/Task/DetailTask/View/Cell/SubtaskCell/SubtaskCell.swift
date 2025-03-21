//
//  SubtaskCell.swift
//  ProMag
//
//  Created by Christian Wiradinata on 06/06/23.
//

import UIKit
import Common

class SubtaskCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with title: String) {
        titleLbl.text = title
    }
}
