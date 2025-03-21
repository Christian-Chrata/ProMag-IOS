//
//  MenuController.swift
//  Common
//
//  Created by Christian Wiradinata on 30/05/23.
//

import UIKit

public struct MenuAction {
    public let title: String?
    public let type: ColorType
    public let completion: (() -> Void)?
    
    public init(title: String?, type: ColorType, completion: (() -> Void)?) {
        self.title = title
        self.type = type
        self.completion = completion
    }
}

public class MenuController: UIViewController {
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var actionStack: UIStackView!
    
    private var actions: [MenuAction] = []
    
    public init() {
        super.init(nibName: "MenuController", bundle: Bundle(identifier: "com.chrata.Common"))
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        for (i, action) in actions.enumerated() {
            let button = Button()
            button.type = action.type.rawValue
            button.tag = i
            button.setTitle(action.title, for: .normal)
            button.addTarget(self, action: #selector(onTapAction(_:)), for: .touchUpInside)
            actionStack.addArrangedSubview(button)
        }
        
        let tapOther = UITapGestureRecognizer(target: self, action: #selector(onTapOther(_:)))
        overlay.addGestureRecognizer(tapOther)
    }
    
    public func addAction(_ action: MenuAction) {
        actions.append(action)
    }
    
    @objc
    private func onTapAction(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.actions[sender.tag].completion?()
        }
    }
    
    @objc
    private func onTapOther(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
