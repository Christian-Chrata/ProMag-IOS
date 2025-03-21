//
//  RoundedView.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

@IBDesignable
public class RoundedView: UIView {
    @IBInspectable public var topLeft: Bool = false      { didSet { setNeedsLayout() } }
    @IBInspectable public var topRight: Bool = false     { didSet { setNeedsLayout() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { setNeedsLayout() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { setNeedsLayout() } }
    @IBInspectable public var cornerRadius: CGFloat = 0  { didSet { setNeedsLayout() } }
    @IBInspectable public var isShadow: Bool = false  { didSet { setNeedsLayout() } }
    @IBInspectable public var isBackgroundColor: UIColor = .clear  { didSet { setNeedsLayout() } }
    private var shadowLayer: CAShapeLayer!
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer != nil {
            shadowLayer.removeFromSuperlayer()
        }
        
        var options = UIRectCorner()
        
        if topLeft     { options.formUnion(.topLeft) }
        if topRight    { options.formUnion(.topRight) }
        if bottomLeft  { options.formUnion(.bottomLeft) }
        if bottomRight { options.formUnion(.bottomRight) }
        
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: options, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        if isShadow {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = path.cgPath
            shadowLayer.fillColor = backgroundColor?.cgColor ?? UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 8
            
            backgroundColor = isBackgroundColor
            layer.insertSublayer(shadowLayer, at: 0)
        }else{
            let maskLayer=CAShapeLayer()
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        }
    }
}
