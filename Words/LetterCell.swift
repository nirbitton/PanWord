//
//  LetterCell.swift
//  Words
//
//  Created by Nir Bitton on 14/01/2018.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

class LetterCell: UICollectionViewCell
{
    @IBOutlet weak var letter: UILabel!
    
    var strText = "ב"
    var IsSelected:Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        letter.text = strText
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

}
