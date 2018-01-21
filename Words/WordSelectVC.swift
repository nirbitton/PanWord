//
//  WordSelectVC.swift
//  Words
//
//  Created by Nir Bitton on 19/10/2017.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CellWordSelect"

class WordSelectVC: UIViewController, UICollectionViewDataSource {
    
    var verticalSpacing  = 15
    var horizontalSpacing = 10
    
    var wordsArr = [[String]]()
    var levelSelectedData:[LevelSelectData] = []
    
    var selectedLevel:Int?

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.backgroundColor = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.00)
        
        let levelSelectData:LevelSelectData = self.levelSelectedData[self.selectedLevel!]
        self.navigationItem.title = levelSelectData.icon! + " " + levelSelectData.levelName!
        
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wordSelected"
        {
            let vcDest = segue.destination as! ViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView?.indexPath(for: cell)
            vcDest.selectedWord = indexPath?.row
            vcDest.wordsArr = wordsArr
            vcDest.levelSelectedData = self.levelSelectedData
            vcDest.selectedLevel = selectedLevel
        }
    }
 
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return wordsArr[selectedLevel!].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WordSelectCell
        
        cell.icon.text = self.levelSelectedData[selectedLevel!].icon
        cell.title.text = (self.levelSelectedData[selectedLevel!].levelName)! + " - " + String(indexPath.row)
        
        cell.isUserInteractionEnabled = false
        cell.icon.alpha = 0.5
        cell.title.alpha = 0.5
        cell.lock.isHidden = false
        
        if DBManager.getSavedLevel() > selectedLevel! {
            cell.isUserInteractionEnabled = true
            cell.lock.isHidden = true
            
            cell.icon.alpha = 1.0
            cell.title.alpha = 1.0
        }
        else if DBManager.getSavedLevel() == selectedLevel! {
            if DBManager.getSavedWord() >= indexPath.row {
                cell.isUserInteractionEnabled = true
                cell.lock.isHidden = true
                
                cell.icon.alpha = 1.0
                cell.title.alpha = 1.0
            }
        }
        
        // Configure the cell
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00).cgColor
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
}

extension WordSelectVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width - CGFloat(horizontalSpacing)*2, height: 88 - CGFloat(horizontalSpacing)*2)
    }
}
