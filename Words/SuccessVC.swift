//
//  SuccessVC.swift
//  Words
//
//  Created by Nir Bitton on 16/10/2017.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation
import LTMorphingLabel

class SuccessVC: UIViewController, NavgationTransitionable, LTMorphingLabelDelegate {
    
    var tr_pushTransition: TRNavgationTransitionDelegate?

    @IBOutlet weak var firstWord: UILabel!
    @IBOutlet weak var secondWord: UILabel!
    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var scoreLbl: LTMorphingLabel!
    
    var levelSelectedData:LevelSelectData?
    var levelScore:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLbl.text = String(DBManager.getScore())
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firstWord.text = levelSelectedData?.levelName
        secondWord.text = getSecondWordByScore()
        emoji.text = levelSelectedData?.icon
        
        delay(0.4) {
            self.scoreLbl.morphingEffect = LTMorphingEffect(rawValue: self.levelScore)!
            let newScore = DBManager.getScore()
            self.scoreLbl.text = String(newScore)
        }
        
    }
    
    func getSecondWordByScore() -> String {
        if levelScore == 6 {
            return "תוצאה מושלמת!"
        }
        else if levelScore == 4 {
            return "מצויין"
        }
        else if levelScore == 2 {
            return "כל הכבוד"
        }
        else {
            return "יפה"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delay(0.98) {
            _ = self.navigationController?.tr_popViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    
    func morphingDidStart(_ label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(_ label: LTMorphingLabel, progress: Float) {
        
    }
    
}
