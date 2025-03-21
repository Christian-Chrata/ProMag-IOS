//
//  Attr.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public struct Attr {
    public let text: String
    public let size: CGFloat
    public let weight: UIFont.Weight
    public let color: UIColor
    
    public init(text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        self.text = text
        self.size = size
        self.weight = weight
        self.color = color
    }
}
