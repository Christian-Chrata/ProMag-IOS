//
//  TeamListCell.swift
//  ProMag
//
//  Created by Christian Wiradinata on 21/04/23.
//

import UIKit
import Common

protocol TeamListCellDelegate {
    func tapDetail(row: Int)
}

class TeamListCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var row = 0
    var delegate: TeamListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapDetail = UITapGestureRecognizer(target: self, action: #selector(onTapDetail(_:)))
        detailLabel.isUserInteractionEnabled = true
        detailLabel.addGestureRecognizer(tapDetail)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setup(with team: TeamListModel, row: Int) {
        borderView.backgroundColor = team.type.viewColor
        titleLabel.textColor = team.type.labelColor
        titleLabel.text = team.name
        self.row = row
    }
    
    @objc func onTapDetail(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.tapDetail(row: row)
    }
}
