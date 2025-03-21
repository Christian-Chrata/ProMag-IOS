//
//  UINavigationBar+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public extension UINavigationBar {
    enum NavigationBarKind {
        case solid(color: UIColor)
        case transparent(translucent: Bool)
        case curve(color: UIColor)
    }
    
    func configure(with type: NavigationBarKind) {
        switch type {
        case .solid(let color):
            shadowImage         = UIImage()
            isTranslucent       = false
            tintColor           = UIView().tintColor
            barTintColor        = color
            titleTextAttributes = [
                NSAttributedString.Key(
                    rawValue: NSAttributedString.Key.foregroundColor.rawValue
                ): UIColor.black
            ]
            backgroundColor     = color
        case .transparent(let translucent):
            setBackgroundImage(UIImage(), for: .default)
            shadowImage         = UIImage()
            isTranslucent       = translucent
            tintColor           = UIColor.white
            titleTextAttributes = [
                NSAttributedString.Key(
                    rawValue: NSAttributedString.Key.foregroundColor.rawValue
                ): UIColor.white
            ]
            barTintColor        = UIColor.clear
            backgroundColor     = UIColor.clear
        case .curve(let color):
            shadowImage         = UIImage()
            isTranslucent       = false
            tintColor           = UIView().tintColor
            barTintColor        = color
            titleTextAttributes = [
                NSAttributedString.Key(
                    rawValue: NSAttributedString.Key.foregroundColor.rawValue
                ): UIColor.black
            ]
            backgroundColor     = color
            
            setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            shadowImage = UIImage()
            
            let shadowView = UIView(frame: CGRect(x: 0, y: bounds.maxY , width: (bounds.width), height: 20))
            
            shadowView.backgroundColor = .clear
            insertSubview(shadowView, at: 1)
            
            let shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            
            shadowLayer.fillColor = color.cgColor
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 4.0)
            shadowLayer.shadowOpacity = 0.1
            shadowLayer.shadowRadius = 1
            shadowView.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
