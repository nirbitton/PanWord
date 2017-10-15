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
    }
}
