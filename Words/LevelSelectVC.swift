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
//        self.collectionView!.backgroundColor = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.00)
        self.collectionView!.backgroundColor = UIColor.clear
        
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
        
        let animals = LevelSelectData(icon: "🐮", levelName: "חיות", nunOfWords: "")
        self.addToLevelsArr(levelNumber: 0, levelSelectData: animals, savedLevel: savedLevel, savedWord: savedWord)
        
        let names = LevelSelectData(icon: "👶", levelName: "שמות", nunOfWords: "")
        self.addToLevelsArr(levelNumber: 1, levelSelectData: names, savedLevel: savedLevel, savedWord: savedWord)
        
        let colors = LevelSelectData(icon: "🌈", levelName: "צבעים", nunOfWords: "")
        self.addToLevelsArr(levelNumber: 2, levelSelectData: colors, savedLevel: savedLevel, savedWord: savedWord)
        
        let food = LevelSelectData(icon: "🍲", levelName: "מאכלים", nunOfWords: "")
        self.addToLevelsArr(levelNumber: 3, levelSelectData: food, savedLevel: savedLevel, savedWord: savedWord)
        
        let body = LevelSelectData(icon: "👁️", levelName: "גוף האדם", nunOfWords: "")
        self.addToLevelsArr(levelNumber: 4, levelSelectData: body, savedLevel: savedLevel, savedWord: savedWord)
        
        let countries = LevelSelectData(icon: "🗺️", levelName: "מדינות", nunOfWords: "0/10")
        self.addToLevelsArr(levelNumber: 5, levelSelectData: countries, savedLevel: savedLevel, savedWord: savedWord)
        
        let bible = LevelSelectData(icon: "📖", levelName: "תנ״ך", nunOfWords: "0/10")
        self.addToLevelsArr(levelNumber: 6, levelSelectData: bible, savedLevel: savedLevel, savedWord: savedWord)
        
        let professions = LevelSelectData(icon: "🎭", levelName: "מקצועות", nunOfWords: "0/10")
        self.addToLevelsArr(levelNumber: 7, levelSelectData: professions, savedLevel: savedLevel, savedWord: savedWord)
        
        
//        levelsArr.append(LevelSelectData(icon: "🎬", levelName: "סרטים", nunOfWords: "0/10"))
//        levelsArr.append(LevelSelectData(icon: "📖", levelName: "תנ״ך", nunOfWords: "0/10"))
//        levelsArr.append(LevelSelectData(icon: "🎙️", levelName: "מוזיקה", nunOfWords: "0/10"))
//        levelsArr.append(LevelSelectData(icon: "🎭", levelName: "מקצועות", nunOfWords: "0/10"))
        
    }
    
    func addToLevelsArr(levelNumber:Int, levelSelectData:LevelSelectData, savedLevel:Int, savedWord:Int) {
        
        if savedLevel > levelNumber {
            levelsArr.append(LevelSelectData(icon: levelSelectData.icon!, levelName: levelSelectData.levelName!, nunOfWords: String(wordsArr[levelNumber].count) + "/" + String(wordsArr[levelNumber].count)))
        }
        else if savedLevel == levelNumber {
            levelsArr.append(LevelSelectData(icon: levelSelectData.icon!, levelName: levelSelectData.levelName!, nunOfWords: String(savedWord) + "/" + String(wordsArr[levelNumber].count)))
        }
        else {
            levelsArr.append(LevelSelectData(icon: levelSelectData.icon!, levelName: levelSelectData.levelName!, nunOfWords: "0/" + String(wordsArr[levelNumber].count)))
        }
    }
    
    func initWords() {
        wordsArr.removeAll()
        let animals = ["אריה","תנינ","נמלה","זבוב","יתוש","לטאה","עכבר","חתול","שועל","חמור","פרפר"]
        let names = ["ימית","לביא","בארי","אביה","דפנה","איתנ","מאיר","יוספ","ברוכ","אסתר","יקיר","הילה","תומר","רוננ","בתיה","דרור","כרמל","ירדנ","מרימ","אמיר","שרונ","מיקי","יאיר"]
        let colors = ["אדומ","צהוב","ירוק","כחול","שחור","כתומ","ורוד","תכלת","סגול","ציאנ","אפור"]
        let food = ["פיצה","במבה","ביצה","פסטה","חציל","גמבה","פיתה","ציפס","תפוח","חלבה","טוסט","מעדנ","עוגה","כרוב"]
        let body = ["אוזנ","מרפק","לשונ","אצבע","פנימ","טבור","זרוע","ריאה","בוהנ"]
        let countries = ["גאנה","בליז","בנינ","הודו","יוונ","ירדנ","לאוס","ליטא","מאלי","מלטה","נפאל","סנגל","ספרד","פנמה","צרפת","קנדה","קניה","תימנ"]
        let bible = ["תורה","שמות","הושע","יואל","בארי","עמוס","יונה","מיכה","נחומ","משלי","איוב","איכה","קהלת","אסתר","שלמה","עזרא","רבקה","פרעה","יצחק","נביא","עשיו","שאול","בעשא","אחאב","יעקב"]
        let professions = ["רופא","מורה","מנהל","אופה","אספנ","בלדר","בלשנ","בנאי","במאי","שוטר","מציל","כבאי","זבלנ","ברמנ","גובה","חבלנ","מרגל","משרת","סוהר","ליצנ","חזאי","מאלפ","מדענ","חלבנ","גזבר","מלצר","מנחה","צורפ","פקיד","מנתח","יועצ","הגאי","יחצנ","מנקה","רוקח","קלדנ","ספרנ","פועל","מכשפ","חלפנ","סוכנ","חובש","סופר","קוסמ","רקדנ","ימאי","מעצב","חובל","ירקנ","סריס","שחקנ","תופר","מנצח","גולש","חקינ","שומר","משיט","כורת","חדשנ","חותר","חרזנ"]
        
        
        wordsArr.append(animals)
        wordsArr.append(names)
        wordsArr.append(colors)
        wordsArr.append(food)
        wordsArr.append(body)
        wordsArr.append(countries)
        wordsArr.append(bible)
        wordsArr.append(professions)
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
        cell?.layer.borderColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00).cgColor
        
        if indexPath.row == 0 || (DBManager.getSavedLevel() >= indexPath.row && indexPath.row < 4) {
            cell?.isUserInteractionEnabled = true
            cell?.lock.isHidden = true
            cell?.layer.borderColor = UIColor.lightGray().cgColor
            
            cell?.icon.alpha = 1.0
            cell?.levelName.alpha = 1.0
            cell?.numOfWords.alpha = 1.0
        }
        
        // Configure the cell
        cell?.layer.cornerRadius = 5
        cell?.layer.borderWidth = 1.0
        cell?.backgroundColor = UIColor.offWhite()
    
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
