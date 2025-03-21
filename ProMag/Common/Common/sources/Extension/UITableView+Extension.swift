//
//  UITableView+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public extension UITableView {
    func setEmptyView(image: UIImage? = nil, title: String, message: String) {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        let emptyView = UIStackView()
        emptyView.axis = .vertical
        emptyView.alignment = .center
        emptyView.spacing = 8
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if image != nil {
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addArrangedSubview(imageView)
        emptyView.addArrangedSubview(titleLabel)
        emptyView.addArrangedSubview(messageLabel)
        horizontalStack.addArrangedSubview(emptyView)
        titleLabel.text = title
        messageLabel.text = message
        titleLabel.numberOfLines = 0
        messageLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = horizontalStack
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
