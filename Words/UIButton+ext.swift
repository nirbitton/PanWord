//
//  UIButton+ext.swift
//  Words
//
//  Created by Nir Bitton on 01/11/2016.
//  Copyright © 2016 Nir. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setRound()
    {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func setLeftRound()
    {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: ([.bottomLeft, .topLeft]), cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        self.clipsToBounds = true
    }
    
    func setRightRound()
    {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: ([.bottomRight, .topRight]), cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        self.clipsToBounds = true
    }
}
