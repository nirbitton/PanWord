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
    
    @IBOutlet weak var hintBtn: UIButton!
    @IBOutlet weak var addHintBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedLetters: UILabel!
    @IBOutlet weak var reffreshBtn: UIButton!
    @IBOutlet weak var letter1: UILabel!
    @IBOutlet weak var letter2: UILabel!
    @IBOutlet weak var letter3: UILabel!
    @IBOutlet weak var letter4: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        
        request = GADRequest()
        request?.testDevices = [ kGADSimulatorID, "0dc5f3047bdc32effffee248d68d7ce6" ];
        
        hintBtn.setRightRound()
        let str = "רמז" + "(" + String(DBManager.getSavedHint()) + ")!"
        hintBtn.setTitle(str, for: .normal)
        addHintBtn.setLeftRound()
        reffreshBtn.setRound()
        letter1.setRound()
        letter2.setRound()
        letter3.setRound()
        letter4.setRound()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let doubleTapGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        doubleTapGesture.minimumPressDuration = 0.1
        self.collectionView.addGestureRecognizer(doubleTapGesture)
        
        currentsArr = wordsArr[selectedLevel!]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rewardBasedVideo?.load(request!, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
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
        if let indexPath: NSIndexPath = self.collectionView.indexPathForItem(at: location) as NSIndexPath?
        {
            switch state
            {
            case UIGestureRecognizerState.began:
                
                break
            case UIGestureRecognizerState.changed:
                if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? LetterCell
                {
                    self.handleCellSelection(cell: cell)
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
    }
    
    func success()
    {
        if selectedLetters.text == currentsArr[selectedWord!]
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
            
            UIView.transition(with: letter4, duration: 0.3, options: .transitionCrossDissolve, animations: {() -> Void in
                self.letter4.textColor = UIColor.orange
            }) { _ in }
            
            UIView.transition(with: letter3, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
                self.letter3.textColor = UIColor.orange
            }) { _ in }
            
            UIView.transition(with: letter2, duration: 0.7, options: .transitionCrossDissolve, animations: {() -> Void in
                self.letter2.textColor = UIColor.orange
            }) { _ in }
            
            UIView.transition(with: letter1, duration: 0.9, options: .transitionCrossDissolve, animations: {() -> Void in
                self.letter1.textColor = UIColor.orange
            }) { _ in }
            
            delay(0.5) {
                let successVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessVC") as! SuccessVC
                successVC.levelSelectedData = self.levelSelectedData[self.selectedLevel!]
                self.navigationController?.tr_pushViewController(successVC, method: TRPushTransitionMethod.page)
            }
            
            
            delay(0.9) {
                self.nextPage()
            }
        }
    }
    
    func nextPage() {
        selectedWord = selectedWord!+1
        collectionView.reloadData()
        
        letter4.text = ""
        letter3.text = ""
        letter2.text = ""
        letter1.text = ""
        
        clearCells()
        
        DBManager.saveWord(word: selectedWord!)
    }
    
    @IBAction func reffreshAction(_ sender: Any) {
        selectedWord = selectedWord!+1
        collectionView.reloadData()
        
        letter4.text = ""
        letter3.text = ""
        letter2.text = ""
        letter1.text = ""
        
        clearCells()
    }
    func handleCellSelection(cell:LetterCell)
    {
        if !selectedTags.contains(cell)
        {
            selectedTags.append(cell)
            cell.backgroundColor = UIColor.cellDarkBlueColor()
            cell.letter.textColor = UIColor.orange
            
            selectedLetters.text = selectedLetters.text! + cell.letter.text!
        }
        else
        {
            if selectedTags.count > 1
            {
                if cell.tag == selectedTags[selectedTags.endIndex-2].tag
                {
                    let lastCell = selectedTags[selectedTags.endIndex-1]
                    lastCell.backgroundColor = UIColor.cellColor()
                    lastCell.letter.textColor = UIColor.offWhiteColor()
                    
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
            cell.backgroundColor = UIColor.cellColor()
            cell.letter.textColor = UIColor.offWhiteColor()
        }
        selectedTags.removeAll()
        selectedLetters.text = ""
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if selectedWord! == currentsArr.count {
            selectedLevel = selectedLevel!+1
            currentsArr = wordsArr[selectedLevel!]
            selectedWord = 0
            DBManager.saveWord(word: selectedWord!)
            
            if DBManager.getSavedLevel() < selectedLevel! {
                DBManager.saveLevel(level: selectedLevel!)
            }
        }
        
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
        
        self.success()
    }
    
    @IBAction func handlePan(_ gesture:UIPanGestureRecognizer)
    {
        let state: UIGestureRecognizerState = gesture.state
        let location:CGPoint = gesture.location(in: self.collectionView)
        if let indexPath: NSIndexPath = self.collectionView.indexPathForItem(at: location) as NSIndexPath?
        {
            switch (state)
            {
            case UIGestureRecognizerState.began:
                break
            case .possible:
                if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? LetterCell
                {
                    if let label = cell.letter
                    {
                        self.handleCellSelection(cell: cell)
                    }
                }
                break
            case UIGestureRecognizerState.changed:
                if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? LetterCell
                {
                    if let label = cell.letter
                    {
                        self.handleCellSelection(cell: cell)
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
        return CGSize(width: 155, height: 155)
    }
}

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
