//
//  CommentCell.swift
//  ProMag
//
//  Created by Christian Wiradinata on 05/06/23.
//

import UIKit
import Common

class CommentCell: UITableViewCell {
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with comment: CommentModel) {
        
        let initial = comment.fullname
        
        initialLbl.text = initial[initial.startIndex].uppercased()
        usernameLbl.text = comment.fullname
        
        let date = comment.commentPostDate.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")?.toString(dateFormat: "dd MMM yyyy")
        dateLabel.text = date
        
        commentLbl.text = comment.comment
    }
}
