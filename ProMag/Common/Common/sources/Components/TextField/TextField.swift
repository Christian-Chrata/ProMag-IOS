//
//  TextField.swift
//  Common
//
//  Created by Christian Wiradinata on 09/01/23.
//

import UIKit

public protocol DefaultTextField where Self: DTTextField {
    var type: InputType { get set }
}

public class TextField: DTTextField, DefaultTextField {
    public var isRequired: Bool = true
    public var type: InputType = .text
    public override var isEnabled: Bool {
        willSet {
            textColor = newValue ? .black : .lightGray
            tintColor = newValue ? UIView().tintColor : .red
        }
    }
    
    lazy var dropdownButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.height/2, height: self.frame.height/2))
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = UIColor.lightGray
        return button
    }()
    
    lazy var secureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.height/2, height: self.frame.height/2))
        button.setImage(hideImage, for: .normal)
        button.setImage(showImage, for: .selected)
        button.tintColor = UIColor.lightGray
        button.addTarget(self, action: #selector(onTapShowPassword(_:)), for: .touchUpInside)
        return button
    }()
    
    private var showImage: UIImage? = UIImage(systemName: "eye.slash") {
        didSet {
            secureButton.tintColor = tintColor
            secureButton.setImage(showImage, for: .selected)
        }
    }
  
    private var hideImage: UIImage? = UIImage(systemName: "eye") {
        didSet {
            secureButton.tintColor = tintColor
            secureButton.setImage(hideImage, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
       
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 4
        return rect
    }
    
    public func setup() {
        switch type {
        case .text:
            keyboardType = .default
        case .name:
            keyboardType = .default
        case .number:
            keyboardType = .numberPad
        case .email:
            keyboardType = .emailAddress
            textContentType = .emailAddress
        case .phone:
            keyboardType = .phonePad
            textContentType = .telephoneNumber
        case .pass, .loginPass:
            keyboardType = .default
            isSecureTextEntry = true
            rightView = secureButton
            rightViewMode = .always
        case .dropdown:
            keyboardType = .default
            rightView = dropdownButton
            rightViewMode = .always
        }
        
        clearButtonMode = .whileEditing
        addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancel));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([spaceButton, doneButton], animated: false)
        inputAccessoryView = toolbar
        autocorrectionType = .no
        
        textColor = .label
    }
    
    @objc
    func editingChanged(_ sender: UITextField) {
        validate()
    }
    
    @objc
    func cancel() {
        endEditing(true)
    }
    
    
    @objc
    private func onTapShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = !sender.isSelected
    }
    
    public func validate() {
        guard
            let text = text?.trimmingCharacters(in: .whitespaces),
            isRequired == true
        else { return }
        
        let isValid = text.regex(with: type.regex)
        
        if isValid {
            hideError()
        } else {
            showError(message: type.error)
        }
    }
}
