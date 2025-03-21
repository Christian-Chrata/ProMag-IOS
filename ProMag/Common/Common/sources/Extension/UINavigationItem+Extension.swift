//
//  UINavigationItem+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public extension UINavigationItem {
    static func setTitle(title: String, subtitle: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleView = UIStackView()
        titleView.addArrangedSubview(titleLabel)
        titleView.addArrangedSubview(subtitleLabel)
        titleView.axis = .vertical
        titleView.sizeToFit()
        
        return titleView
    }
}

public extension UIApplication {
    static func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
    }
}
