//
//  UIView+ext.swift
//  Words
//
//  Created by Nir Bitton on 23/10/2017.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

extension UIView {
    
    func setRound1()
    {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    
    func gradient(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint, opacity: Float, location: [NSNumber]?) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.opacity = opacity
        gradientLayer.locations = location
        layer.addSublayer(gradientLayer)
    }
    
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
}
