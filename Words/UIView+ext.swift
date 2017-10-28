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
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
