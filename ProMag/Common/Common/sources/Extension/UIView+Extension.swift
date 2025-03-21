//
//  UIView+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public extension UIView {
    func applyGradient(colors: [CGColor], location: [NSNumber]? = nil, position: CALayer.Position = .vertical) {
        let gradientLayer = CALayer.gradient(
            colors: colors,
            location: location,
            position: position,
            cornerRadius: self.layer.cornerRadius,
            bounds: self.bounds)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset  = offset
        layer.shadowColor   = color.cgColor
        layer.shadowRadius  = radius
        layer.shadowOpacity = opacity
        layer.shadowPath    = UIBezierPath.init(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        
        let backgroundCGColor   = self.backgroundColor?.cgColor
        self.backgroundColor    = nil
        layer.backgroundColor   =  backgroundCGColor
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func shimmer(colors: [CGColor], location: [NSNumber]? = nil, position: CALayer.Position = .vertical, key: String) {
        let gradientLayer = CALayer.gradient(
            colors: colors,
            location: location,
            position: position,
            cornerRadius: self.layer.cornerRadius,
            bounds: self.bounds)
        self.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -self.frame.width
        animation.toValue = self.frame.width
        animation.repeatCount = .infinity
        animation.duration = 2
        
        gradientLayer.add(animation, forKey: key)
    }
}

@IBDesignable
public class DashView: UIView {
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 7
    @IBInspectable var betweenDashesSpace: CGFloat = 3
    
    public var dashBorder: CAShapeLayer?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = dashColor.cgColor
        shapeLayer.lineWidth = dashWidth
        shapeLayer.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: self.bounds.minX, y: self.bounds.minY), CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
        self.dashBorder = shapeLayer
    }
}
