//
//  StartPageVC.swift
//  Words
//
//  Created by Nir Bitton on 23/10/2017.
//  Copyright © 2017 Nir. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StartPageVC: UIViewController, GADRewardBasedVideoAdDelegate {

    @IBOutlet weak var letter1: UIView!
    @IBOutlet weak var letter2: UIView!
    @IBOutlet weak var letter3: UIView!
    @IBOutlet weak var letter4: UIView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var hintsBtn: UIButton!
    
    var rewardBasedVideo: GADRewardBasedVideoAd?
    var request: GADRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBtn.setRound()
        hintsBtn.setRound()
        
        letter1.setRound1()
        letter2.setRound1()
        letter3.setRound1()
        letter4.setRound1()
        
        if !DBManager.isHintAllreadySet() {
            DBManager.setBooleanHintAsTrue()
            DBManager.addHint(hint: 3)
        }
        
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let str = " קבל עוד רמזים" + " (" + String(DBManager.getSavedHint()) + ") "
        hintsBtn.setTitle(str, for: .normal)
        
        // Use in tesing
        request = GADRequest()
        request?.testDevices = [ kGADSimulatorID, "0dc5f3047bdc32effffee248d68d7ce6" ];
        rewardBasedVideo?.load(request!, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        // Use in production
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: DBManager.ADMOB_AD_UNIT_ID)
    }
    
    @IBAction func addHints(_ sender: Any) {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        
        DBManager.addHint(hint: NSInteger(reward.amount) == 1 ? NSInteger(reward.amount) : 1)
        
        let str = " קבל עוד רמזים" + " (" + String(DBManager.getSavedHint()) + ") "
        hintsBtn.setTitle(str, for: .normal)
        
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
