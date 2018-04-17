//
//  ViewController.swift
//  Words
//
//  Created by Nir Bitton on 28/10/2016.
//  Copyright © 2016 Nir. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation
import GoogleMobileAds

class ViewController: UIViewController, UICollectionViewDataSource, GADRewardBasedVideoAdDelegate {
    
    var selectedTags:[LetterCell] = []
    var wordAsArray:[Character] = []
    var wordsArr = [[String]]()
    var currentsArr:[String] = []
    var levelSelectedData:[LevelSelectData] = []
    
    var tr_presentTransition: TRViewControllerTransitionDelegate?
    
    var selectedWord:Int?
    var selectedLevel:Int?
    
    var rewardBasedVideo: GADRewardBasedVideoAd?
    var request: GADRequest?
    
    // Show message when user taps on screen without
    var numberOfTaps:Int?
    
    // for score
    var numberOfTries:Int = 0
    var isSameTry:Bool = false
    
    
    @IBOutlet weak var hintBtn: UIButton!
    @IBOutlet weak var addHintBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedLetters: UILabel!
    @IBOutlet weak var reffreshBtn: UIButton!
    @IBOutlet weak var letter1: UILabel!
    @IBOutlet weak var letter2: UILabel!
    @IBOutlet weak var letter3: UILabel!
    @IBOutlet weak var letter4: UILabel!
    @IBOutlet weak var backGView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        
        request = GADRequest()
        request?.testDevices = [ kGADSimulatorID, "0dc5f3047bdc32effffee248d68d7ce6" ];
        
//        hintBtn.setRightRound()
        let str = "רמז" + "(" + String(DBManager.getSavedHint()) + ")!"
        hintBtn.setTitle(str, for: .normal)
        addHintBtn.setRound()
//        reffreshBtn.setRound()
        hintBtn.setRound(10)
//        reffreshBtn.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        letter1.setRound()
        letter2.setRound()
        letter3.setRound()
        letter4.setRound()
        backGView.setRound1()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        let doubleTapGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        doubleTapGesture.minimumPressDuration = 0.01
        self.collectionView.addGestureRecognizer(doubleTapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rewardBasedVideo?.load(request!, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        currentsArr = wordsArr[selectedLevel!]
        let levelSelectData:LevelSelectData = self.levelSelectedData[self.selectedLevel!]
        self.navigationItem.title = levelSelectData.icon! + " " + levelSelectData.levelName!
        
        // Use in production
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: DBManager.ADMOB_AD_UNIT_ID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleTap(_ sender: UITapGestureRecognizer)
    {
        let state: UIGestureRecognizerState = sender.state
        let location:CGPoint = sender.location(in: self.collectionView)
        switch state
        {
        case .began:
            break
        case .changed:
            if let indexPath: NSIndexPath = self.collectionView.indexPathForItem(at: location) as NSIndexPath?
            {
                if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? LetterCell
                {
                    self.handleCellSelection(cell: cell)
                }
            }
            break
        case .ended:
            success()
            clearCells()
            
            isSameTry = false
            break
        default:
            break
        }
        self.handleNumOfTries()
    }
    
    func success()
    {
        if selectedLetters.text == currentsArr[selectedWord!] || !(letter1.text?.isEmpty)!
        {
            //success
            var arr:[Character] = []
            let str:String = currentsArr[selectedWord!] as String
            if wordAsArray.count == 0 {
                arr = Array(str.characters)
            }
            letter4.text = arr[0].description
            letter3.text = arr[1].description
            letter2.text = arr[2].description
            letter1.text = arr[3].description
            
            letter4.animate(time: 0.3)
            letter3.animate(time: 0.5)
            letter2.animate(time: 0.7)
            letter1.animate(time: 0.9)
            
            delay(0.5) {
                self.nextPage()
                self.saveData()
            }
            
            delay(0.9) {
                self.clearUI()
            }
        }
    }
    
    func nextPage() {
        let successVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessVC") as! SuccessVC
        successVC.levelSelectedData = self.levelSelectedData[self.selectedLevel!]
        successVC.levelScore = self.getTotalScore()
        self.navigationController?.tr_pushViewController(successVC, method: TRPushTransitionMethod.fade)
    }
    
    func saveData() {
        selectedWord = selectedWord! + 1
        
        // new level
        if selectedWord! == currentsArr.count {
            selectedLevel = selectedLevel!+1
            currentsArr = wordsArr[selectedLevel!]
            selectedWord = 0
            
            
            if DBManager.getSavedLevel() < selectedLevel! {
                DBManager.saveLevel(level: selectedLevel!)
                DBManager.saveWord(word: selectedWord!)
            }
        }// new word
        else if DBManager.getSavedLevel() == selectedLevel, DBManager.getSavedWord() < selectedWord! {
            DBManager.saveWord(word: selectedWord!)
            DBManager.saveScore(score: self.getTotalScore())
        }
    }
    
    func clearUI() {
        
        collectionView.reloadData()
        
        letter4.text = ""
        letter3.text = ""
        letter2.text = ""
        letter1.text = ""
        
        clearCells()
        
        numberOfTries = 0
    }
    
    func getTotalScore() ->Int {
        if numberOfTries == 1 {
            return 6
        }
        else if numberOfTries == 2 {
            return 4
        }
        else if numberOfTries == 3 {
            return 2
        }
        else {
            return 1
        }
    }
    
    @IBAction func reffreshAction(_ sender: Any) {
        clearCells()
    }
    func handleCellSelection(cell:LetterCell)
    {
        if !selectedTags.contains(cell)
        {
            selectedTags.append(cell)
            cell.backgroundColor = UIColor.midPurple()
            cell.letter.textColor = UIColor.nOrangeColor()
            
            selectedLetters.text = selectedLetters.text! + cell.letter.text!
        }
        else
        {
            if selectedTags.count > 1
            {
                if cell.tag == selectedTags[selectedTags.endIndex-2].tag
                {
                    let lastCell = selectedTags[selectedTags.endIndex-1]
                    lastCell.backgroundColor = UIColor.lightPurple()
                    lastCell.letter.textColor = UIColor.darkPurple()
                    
                    selectedLetters.text!.remove(at:selectedLetters.text!.index(before: selectedLetters.text!.endIndex))
                    selectedTags.remove(at: selectedTags.endIndex-1)
                }
            }
        }
    }
    
    func clearCells()
    {
        for cell in selectedTags
        {
            cell.backgroundColor = UIColor.lightPurple()
            cell.letter.textColor = UIColor.darkPurple()
        }
        selectedTags.removeAll()
        selectedLetters.text = ""
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let str:String = currentsArr[selectedWord!] as String
        if wordAsArray.count == 0
        {
            wordAsArray = Array(str.characters)
        }
        
        if indexPath.row == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCell
            let randomIndex = Int(arc4random_uniform(UInt32(wordAsArray.count)))
            let caf = wordAsArray.remove(at: randomIndex)
            cell.strText = caf.description
            cell.tag = 0
            
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCell
            let randomIndex = Int(arc4random_uniform(UInt32(wordAsArray.count)))
            let caf = wordAsArray.remove(at: randomIndex)
            cell.strText = caf.description
            cell.tag = 1
            
            return cell
        }
        else if indexPath.row == 2
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCell
            let randomIndex = Int(arc4random_uniform(UInt32(wordAsArray.count)))
            let caf = wordAsArray.remove(at: randomIndex)
            cell.strText = caf.description
            cell.tag = 2
            
            return cell
        }
        else if indexPath.row == 3
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCell
            let randomIndex = Int(arc4random_uniform(UInt32(wordAsArray.count)))
            let caf = wordAsArray.remove(at: randomIndex)
            cell.strText = caf.description
            cell.tag = 3
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }

    @IBAction func addHints(_ sender: Any) {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
        else {
            rewardBasedVideo?.load(request!, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
            
            // Use in production
            //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: DBManager.ADMOB_AD_UNIT_ID)
        }
    }
    
    @IBAction func hintAction(_ sender: AnyObject)
    {
        if DBManager.getSavedHint() > 0 {
            DBManager.addHint(hint: -1)
            
            let str = "רמז" + "(" + String(DBManager.getSavedHint()) + ")!"
            hintBtn.setTitle(str, for: .normal)
        }
        else {
            return
        }
        
        var arr:[Character] = []
        let str:String = currentsArr[selectedWord!] as String
        if wordAsArray.count == 0 {
            arr = Array(str.characters)
        }
        
        if (letter4.text?.isEmpty)! {
            let caf = arr[0]
            letter4.text = caf.description
        }
        else if (letter3.text?.isEmpty)! {
            let caf = arr[1]
            letter3.text = caf.description
        }
        else if (letter2.text?.isEmpty)! {
            let caf = arr[2]
            letter2.text = caf.description
        }
        else if (letter1.text?.isEmpty)! {
            let caf = arr[3]
            letter1.text = caf.description
        }
        
        let btnHint = "רמז" + "(" + String(DBManager.getSavedHint()) + ")!"
        hintBtn.setTitle(btnHint, for: .normal)
        
        numberOfTries = numberOfTries + 1
        
        self.success()
    }
    
    @IBAction func handlePan(_ gesture:UIPanGestureRecognizer)
    {
        let state: UIGestureRecognizerState = gesture.state
        let location:CGPoint = gesture.location(in: self.collectionView)
        switch (state)
        {
        case UIGestureRecognizerState.began:
            break
        case .possible:
            if let indexPath: NSIndexPath = self.collectionView.indexPathForItem(at: location) as NSIndexPath?
            {
                if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? LetterCell
                {
                    if let label = cell.letter
                    {
                        self.handleCellSelection(cell: cell)
                    }
                }
            }
            break
        case UIGestureRecognizerState.changed:
            if let indexPath: NSIndexPath = self.collectionView.indexPathForItem(at: location) as NSIndexPath?
            {
                if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? LetterCell
                {
                    if let label = cell.letter
                    {
                        self.handleCellSelection(cell: cell)
                    }
                }
            }
            break
        case UIGestureRecognizerState.ended:
            success()
            
            clearCells()
            break
        default:
            break
        }
        
        
    }
    
    func handleNumOfTries() {
        // check number of tries
        if selectedTags.count > 1 && !isSameTry
        {
            numberOfTries = numberOfTries + 1
            isSameTry = true
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        
        DBManager.addHint(hint: NSInteger(reward.amount) == 1 ? NSInteger(reward.amount) : 1)
        
        let str = "רמז" + "(" + String(DBManager.getSavedHint()) + ")!"
        hintBtn.setTitle(str, for: .normal)
        
        // Use in tesing
        rewardBasedVideo?.load(request!, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        // Use in production
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: DBManager.ADMOB_AD_UNIT_ID)
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        // Use in tesing
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "0dc5f3047bdc32effffee248d68d7ce6" ];
        
        rewardBasedVideo?.load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        // Use in production
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: DBManager.ADMOB_AD_UNIT_ID)
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 667) {
            return CGSize(width: 155.0, height: 155.0)
        }

        return CGSize(width: (self.view.frame.width / 2) - 25, height: (self.view.frame.width / 2) - 25)
    }

}

