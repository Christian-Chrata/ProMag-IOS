//
//  Button.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

@IBDesignable
public class Button: UIButton {
    var round: CGFloat = 8
    
    @IBInspectable
    public var type: Int = 0 {
        didSet {
            _type = ColorType(rawValue: type) ?? .primary
        }
    }
    
    private var _type: ColorType = .primary {
        didSet {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func prepareForInterfaceBuilder() {
        setup()
    }
    
    
    public func setup() {
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        clipsToBounds = true
        layer.cornerRadius = round
        layer.borderWidth = _type.borderWidth
        layer.borderColor = _type.textColor.cgColor
        tintColor = _type.textColor
        accessibilityLabel = titleLabel?.text
        setTitleColor(_type.textColor, for: .normal)
        setTitleColor(_type.backgroundColor, for: .highlighted)
        setTitleColor(_type.textColor.withAlphaComponent(0.5), for: .disabled)
        setBackgroundImage(UIImage(color: _type.backgroundColor), for: .normal)
        setBackgroundImage(UIImage(color: _type.textColor), for: .highlighted)
    }
}
