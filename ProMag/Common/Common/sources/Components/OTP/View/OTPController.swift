//
//  OTPController.swift
//  Common
//
//  Created by Christian Wiradinata on 15/04/23.
//

import UIKit
import Networking

public protocol OTPControllerDelegate {
    func sentOTP(completion: @escaping ((ViewState<Void>) -> Void))
    func submit(with otp: String)
}

public class OTPController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var otpText: TextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var resentLabel: UILabel!
    
    private var viewModel = OTPViewModel()
    public var delegate: OTPControllerDelegate?
    public var timer: Timer? = nil
    public var timerSeconds: Int = 120

    public init(with viewModel: OTPViewModel) {
        super.init(nibName: "OTPController", bundle: Bundle(identifier: "com.chrata.Common"))
        
        self.viewModel = viewModel
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        otpText.delegate = self
        otpText.isEnabled = self.viewModel.textFields[0].enabled
        otpText.type = self.viewModel.textFields[0].type
        otpText.isRequired = self.viewModel.textFields[0].isRequired
        otpText.placeholder = self.viewModel.textFields[0].placeholder
        otpText.text = self.viewModel.textFields[0].value
        otpText.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        otpText.setup()
        
        confirmButton.addTarget(self, action: #selector(onTapConfirm(_:)), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(onTapDismiss(_:)), for: .touchUpInside)
        
        messageLabel.attributedText = UILabel.buildAttributtedString(with: [
            Attr(text: "An 6 digit code has been sent to ", size: 16, weight: .regular, color: Color.label),
            Attr(text: "\(viewModel.getEmail())", size: 16, weight: .medium, color: Color.label)
        ])
        
        resentLabel.isUserInteractionEnabled = true
        let tapResent = UITapGestureRecognizer(target: self, action: #selector(onTapResent(_:)))
        isAbleToResent(with: true)
        resentLabel.addGestureRecognizer(tapResent)
        
        confirmButton.addTarget(self, action: #selector(onTapConfirm(_:)), for: .touchUpInside)
        
        CustomFunction.shared.setKeyboard(with: scrollView)
        
        otpText.becomeFirstResponder()
        
        sentOTP()
    }
    
    private func isAbleToResent(with able: Bool) {
        switch able {
        case true:
            resentLabel.isUserInteractionEnabled = true
            resentLabel.attributedText = UILabel.buildAttributtedString(with: [
                Attr(text: "If you didn't receive a code? ", size: 16, weight: .regular, color: Color.label),
                Attr(text: "Resend", size: 16, weight: .bold, color: Color.primary)
            ])
        case false:
            resentLabel.isUserInteractionEnabled = false
            resentLabel.attributedText = UILabel.buildAttributtedString(with: [
                Attr(text: "If you didn't receive a code? ", size: 16, weight: .regular, color: Color.label),
                Attr(text: "\(getTimeString(sec: self.timerSeconds))", size: 16, weight: .regular, color: Color.label)
            ])
        }
    }
    
    @objc
    private func onTapDismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc
    private func onTapConfirm(_ sender: UIButton) {
        submit()
    }
    
    @objc
    private func onTapResent(_ sender: UIButton) {
        sentOTP()
    }
    
    @objc
    private func didChange(_ sender: UITextField) {
        guard let text = sender.text else {return}
        let count = text.count
        if count > 6 {
            let newString = String(text.dropLast())
            otpText.text = newString
        }
        
        if count == 6 {
            submit()
        }
    }
    
    private func sentOTP() {
        delegate?.sentOTP() { (state) in
            DispatchQueue.main.async { [weak self] in
                switch state {
                case .success:
                    self?.timerStart()
                default: break
                }
            }
        }
    }
    
    private func getTimeString(sec: Int) -> String{
        let minute = sec / 60
        let second = sec % 60
        
        var time = ""
        minute < 10 ? (time = "0\(minute)") : (time = "\(minute)")
        second < 10 ? (time = "\(time):0\(second)") : (time = "\(time):\(second)")
        return time
    }
    
    private func timerStart() {
        if(timer == nil){
            // MARK: hit api resend
            
            // start count down
            timerSeconds = 120
            
            if timerSeconds < 1 {
                
            } else {
                // count down
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                    self.timerSeconds -= 1
                    
                    self.isAbleToResent(with: false)
                    
                    if self.timerSeconds == 0 || self.timerSeconds < 0 {
                        self.timeOut()
                        self.isAbleToResent(with: true)
                    }
                })
            }
        }
    }
    
    func timeOut() {
        timer?.invalidate()
        timer = nil
        timerSeconds = 0
    }
    
    private func submit() {
        guard let text = otpText.text else { return }
        self.viewModel.textFields[0].value = text
        otpText.validate()
        otpText.resignFirstResponder()
        
        guard CustomFunction.shared.validate(with: viewModel.textFields) else {
            let alert = AlertController(with: .warning(message: CustomFunction.shared.getError()))
            alert.addAction(AlertAction(title: "OKAY", type: .primary, completion: nil))
            alert.show()
            return
        }
        
        delegate?.submit(with: viewModel.getOTP())
    }
}

extension OTPController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewConstraint.constant = 32
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewConstraint.constant = 139
    }
}
