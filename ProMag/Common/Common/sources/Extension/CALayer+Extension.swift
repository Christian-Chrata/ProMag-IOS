//
//  CALayer+Extension.swift
//  ProMag
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public extension CALayer {
    enum Position {
        case vertical
        case horizontal
        case diagonal
    }
    
    static func gradient(
        colors: [CGColor],
        location: [NSNumber]? = nil,
        position: Position = .vertical,
        cornerRadius: CGFloat = 0.0,
        bounds: CGRect,
        startPoint: CGPoint = .zero,
        endPoint: CGPoint = .zero) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors        = colors
        gradientLayer.locations     = location
        gradientLayer.frame         = bounds
        gradientLayer.cornerRadius  = cornerRadius
        gradientLayer.startPoint    = startPoint
        gradientLayer.endPoint      = endPoint
        
        switch position {
        case .diagonal:
            gradientLayer.startPoint    = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint      = CGPoint(x: 1, y: 0)
        case .vertical:
            gradientLayer.startPoint    = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint      = CGPoint(x: 0, y: 1)
        default:
            gradientLayer.startPoint    = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint      = CGPoint(x: 1, y: 0)
        }
        return gradientLayer
    }
    
}
