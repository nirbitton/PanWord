//
//  LevelSelectCell.swift
//  Words
//
//  Created by Nir Bitton on 21/10/2017.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class LevelSelectCell: UICollectionViewCell {
    
    @IBOutlet weak var numOfWords: UILabel!
    @IBOutlet weak var levelName: UILabel!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var lock: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
