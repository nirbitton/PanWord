//
//  LevelSelectData.swift
//  Words
//
//  Created by Nir Bitton on 21/10/2017.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

class LevelSelectData: NSObject {
    var icon:String?
    var levelName:String?
    var numberOfWords:String?
    
    init(icon:String, levelName:String, nunOfWords:String) {
        self.icon = icon
        self.levelName = levelName
        self.numberOfWords = nunOfWords
    }
}
