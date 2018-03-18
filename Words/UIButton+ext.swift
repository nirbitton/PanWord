//
//  UIButton+ext.swift
//  Words
//
//  Created by Nir Bitton on 01/11/2016.
//  Copyright © 2016 Nir. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setRound(_ cgFloat:CGFloat = 10)
    {
        self.layer.cornerRadius = cgFloat
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
    
    func onTapBounce()
    {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0)
            
            }, completion: { [weak self] finished in
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: UIViewAnimationOptions(), animations: {
                    self?.layer.transform = CATransform3DIdentity
                }, completion: nil)
        })
    }
}
