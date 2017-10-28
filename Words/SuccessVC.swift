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

class SuccessVC: UIViewController, NavgationTransitionable {
    
    var tr_pushTransition: TRNavgationTransitionDelegate?

    @IBOutlet weak var firstWord: UILabel!
    @IBOutlet weak var secondWord: UILabel!
    @IBOutlet weak var emoji: UILabel!
    
    var levelSelectedData:LevelSelectData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firstWord.text = levelSelectedData?.levelName
        emoji.text = levelSelectedData?.icon
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delay(0.8) {
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
