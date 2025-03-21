//
//  AlertController.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public struct AlertAction {
    public let title: String?
    public let type: ColorType
    public let completion: (() -> Void)?
    
    public init(title: String?, type: ColorType, completion: (() -> Void)?) {
        self.title = title
        self.type = type
        self.completion = completion
    }
}

public class AlertController: UIViewController {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var actionStack: UIStackView!
    
    private var actions: [AlertAction] = []
    private var type: AlertType!
    
    public init(with type: AlertType) {
        super.init(nibName: "AlertController", bundle: Bundle(identifier: "com.chrata.Common"))
        
        self.type = type
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        iconImage.image = type.image
        
        if !type.title.isEmpty {
            if type.title.contains("Success :") {
                let value = type.title.replacingOccurrences(of: "Success :", with: "")
                titleText.text = value
            } else {
                titleText.text = type.title
            }
        } else {
            titleText.text = type.title
        }
        
        if !type.message.isEmpty || type.message != "" {
            messageText.isHidden = false
            messageText.attributedText = "<center>\(type.message)</center>".htmlToAttributedString
        }
        
        for (i, action) in actions.enumerated() {
            let button = Button()
            button.type = action.type.rawValue
            button.tag = i
            button.setTitle(action.title, for: .normal)
            button.addTarget(self, action: #selector(onTapAction(_:)), for: .touchUpInside)
            actionStack.addArrangedSubview(button)
        }
        
    }
    
    public func addAction(_ action: AlertAction) {
        actions.append(action)
    }
    
    @objc
    private func onTapAction(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.actions[sender.tag].completion?()
        }
    }
}
