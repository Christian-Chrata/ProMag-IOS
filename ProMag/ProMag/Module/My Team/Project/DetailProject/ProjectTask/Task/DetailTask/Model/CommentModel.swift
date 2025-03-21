//
//  CommentModel.swift
//  ProMag
//
//  Created by Christian Wiradinata on 05/06/23.
//

import Foundation

struct CommentModel {
    let commentId: String
    let comment: String
    let userId: String
    let fullname: String
    let commentPostDate: String
    
    init(commentId: String, comment: String, userId: String, fullname: String, commentPostDate: String) {
        self.commentId = commentId
        self.comment = comment
        self.userId = userId
        self.fullname = fullname
        self.commentPostDate = commentPostDate
    }
}
