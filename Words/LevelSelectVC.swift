//
//  LevelSelectVC.swift
//  Words
//
//  Created by Nir Bitton on 18/10/2017.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LevelSelectVC: UIViewController, UICollectionViewDataSource {
    
    var verticalSpacing  = 15
    var horizontalSpacing = 10
    var levelsArr:[LevelSelectData] = []
    var wordsArr = [[String]]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
//        self.collectionView.register(LevelSelectCell.s, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.00)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initWords()
        initLevels()
        
        collectionView.reloadData()
    }
    
    func initLevels() {
        levelsArr.removeAll()
        let savedLevel = DBManager.getSavedLevel()
        let savedWord = DBManager.getSavedWord()
        if savedLevel > 0 {
            levelsArr.append(LevelSelectData(icon: "🐮", levelName: "חיות", nunOfWords: String(wordsArr[0].count) + "/" + String(wordsArr[0].count)))
        }
        else if savedLevel == 0 {
            levelsArr.append(LevelSelectData(icon: "🐮", levelName: "חיות", nunOfWords: String(savedWord) + "/" + String(wordsArr[0].count)))
        }
        else {
            levelsArr.append(LevelSelectData(icon: "🐮", levelName: "חיות", nunOfWords: "0/" + String(wordsArr[0].count)))
        }
        
        if savedLevel > 1 {
            levelsArr.append(LevelSelectData(icon: "👶", levelName: "שמות", nunOfWords: String(wordsArr[1].count) + "/" + String(wordsArr[1].count)))
        }
        else if savedLevel == 1 {
            levelsArr.append(LevelSelectData(icon: "👶", levelName: "שמות", nunOfWords: String(savedWord) + "/" + String(wordsArr[1].count)))
        }
        else {
            levelsArr.append(LevelSelectData(icon: "👶", levelName: "שמות", nunOfWords: "0/" + String(wordsArr[1].count)))
        }
        
        if savedLevel > 2 {
            levelsArr.append(LevelSelectData(icon: "🍲", levelName: "מאכלים", nunOfWords: String(wordsArr[2].count) + "/" + String(wordsArr[2].count)))
        }
        else if savedLevel == 2{
            levelsArr.append(LevelSelectData(icon: "🍲", levelName: "מאכלים", nunOfWords: String(savedWord) + "/" + String(wordsArr[2].count)))
        }
        else {
            levelsArr.append(LevelSelectData(icon: "🍲", levelName: "מאכלים", nunOfWords: "0/" + String(wordsArr[2].count)))
        }
        
        levelsArr.append(LevelSelectData(icon: "👁️", levelName: "גוף האדם", nunOfWords: "0/10"))
        levelsArr.append(LevelSelectData(icon: "🗺️", levelName: "מדינות", nunOfWords: "0/10"))
        levelsArr.append(LevelSelectData(icon: "🎬", levelName: "סרטים", nunOfWords: "0/10"))
        levelsArr.append(LevelSelectData(icon: "📖", levelName: "תנ״ך", nunOfWords: "0/10"))
        levelsArr.append(LevelSelectData(icon: "🎼", levelName: "מוזיקה", nunOfWords: "0/10"))
    }
    
    func initWords() {
        wordsArr.removeAll()
        let animals = ["אריה","תנין","נמלה","זבוב","יתוש","לטאה","עכבר","חתול","שועל","חמור","פרפר"]
        let names = ["ימית","לביא","אביה","דפנה","איתן","מאיר","בארי","יוסף","ברוך","אסתר","יקיר","הילה","תומר","רונן","בתיה","דרור","כרמל","ירדן","מרים","אמיר","שרון","מיקי","יאיר"]
        let food = ["פיצה","במבה","ביצה","פסטה","חציל","גמבה","פיתה","ציפס","תפוח","חלבה","טוסט","מעדן","עוגה","כרוב"]
        wordsArr.append(animals)
        wordsArr.append(names)
        wordsArr.append(food)
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return levelsArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? LevelSelectCell
        
        let levelSD:LevelSelectData = levelsArr[indexPath.row]
        cell?.icon.text = levelSD.icon
        cell?.levelName.text = levelSD.levelName
        cell?.numOfWords.text = levelSD.numberOfWords
        
        cell?.isUserInteractionEnabled = false
        cell?.icon.alpha = 0.5
        cell?.levelName.alpha = 0.5
        cell?.numOfWords.alpha = 0.5
        cell?.lock.isHidden = false
        
        if indexPath.row == 0 || (DBManager.getSavedLevel() >= indexPath.row && indexPath.row < 4) {
            cell?.isUserInteractionEnabled = true
            cell?.lock.isHidden = true
            
            cell?.icon.alpha = 1.0
            cell?.levelName.alpha = 1.0
            cell?.numOfWords.alpha = 1.0
        }
        
        // Configure the cell
        cell?.layer.cornerRadius = 5
        cell?.layer.borderWidth = 1.0
        cell?.layer.borderColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00).cgColor
        cell?.backgroundColor = UIColor.white
    
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detail")
        {
            let vcDest = segue.destination as! WordSelectVC
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView?.indexPath(for: cell)
            vcDest.levelSelectedData = levelsArr
            vcDest.selectedLevel = indexPath?.row
            vcDest.wordsArr = self.wordsArr
        }
    }

}

extension LevelSelectVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width - CGFloat(horizontalSpacing)*2, height: 88 - CGFloat(horizontalSpacing)*2)
    }
    
}
