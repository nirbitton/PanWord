//
//  ViewController.swift
//  Words
//
//  Created by Nir Bitton on 28/10/2016.
//  Copyright © 2016 Nir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    var selectedTags:[LetterCell] = []
    var wordAsArray:[Character] = []
    var words:[String] = []
    var currIndex:Int = 0
    
    var numOfHints:Int = 3
    
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
        
        hintBtn.setRightRound()
        let str = "רמז" + "(" + String(numOfHints) + ")!"
        hintBtn.setTitle(str, for: .normal)
        addHintBtn.setLeftRound()
        reffreshBtn.setRound()
        letter1.setRound()
        letter2.setRound()
        letter3.setRound()
        letter4.setRound()
        
        words.append("לביא")
        words.append("משחק")
        words.append("כדור")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let doubleTapGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        doubleTapGesture.minimumPressDuration = 0.1
        self.collectionView.addGestureRecognizer(doubleTapGesture)
        
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
        if selectedLetters.text == words[currIndex]
        {
            //success
            var arr:[Character] = []
            let str:String = words[currIndex] as String
            if wordAsArray.count == 0 {
                arr = Array(str.characters)
            }
            letter4.text = arr[0].description
            letter3.text = arr[1].description
            letter2.text = arr[2].description
            letter1.text = arr[3].description
            
            // add animation
            
        }
    }
    
    @IBAction func reffreshAction(_ sender: Any) {
        currIndex = currIndex+1
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
        let str:String = words[currIndex] as String
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

    @IBAction func hintAction(_ sender: AnyObject)
    {
        if self.numOfHints > 0 {
            numOfHints -= 1
        }
        else {
            numOfHints = 3
//            return
        }
        
        var arr:[Character] = []
        let str:String = words[currIndex] as String
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
        
        let btnHint = "רמז" + "(" + String(numOfHints) + ")!"
        hintBtn.setTitle(btnHint, for: .normal)
        
        self.success()
    }
    
    //    @IBAction func handlePan(_ gesture:UIPanGestureRecognizer)
    //    {
    //        let state: UIGestureRecognizerState = gesture.state
    //        let location:CGPoint = gesture.location(in: self.collectionView)
    //        if let indexPath: NSIndexPath = self.collectionView.indexPathForItem(at: location) as NSIndexPath?
    //        {
    //            switch (state)
    //            {
    //            case UIGestureRecognizerState.began:
    //                break
    //            case .possible:
    //                if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? LetterCell
    //                {
    //                    if let label = cell.letter
    //                    {
    //                        self.handleCellSelection(cell: cell)
    //                    }
    //
    //                }
    //                break
    //            case UIGestureRecognizerState.changed:
    //                if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? LetterCell
    //                {
    //                    if let label = cell.letter
    //                    {
    //                        self.handleCellSelection(cell: cell)
    //                    }
    //
    //                }
    //
    //                break
    //            case UIGestureRecognizerState.ended:
    //                success()
    //
    //                clearCells()
    //                break
    //            default:
    //                break
    //            }
    //        }
    //    }

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
