//
//  UILabel+ext.swift
//  Words
//
//  Created by Nir Bitton on 01/11/2016.
//  Copyright © 2016 Nir. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setRound()
    {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray().cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    func animate(time:TimeInterval)
    {
        self.transform = CGAffineTransform(scaleX: 4, y: 4)
        UIView.animate(withDuration: time, animations: {() -> Void in
            self.transform = CGAffineTransform.identity
            self.textColor = UIColor.darkPurple()
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
}
