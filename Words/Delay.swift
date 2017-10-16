//
//  Delay.swift
//  tlc
//
//  Created by Vladimir Kofman on 28/03/2016.
//  Copyright © 2016 Intel. All rights reserved.
//

import Foundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func rerun(_ closure: @escaping ()->Void,
           checkEvery: TimeInterval = 1.0,
           maxTriesCount: UInt = 60,
           until:@escaping ()->Bool) {
    
    closure()
    
    if maxTriesCount > 0 {
        delay(checkEvery) {
            if until() { return }
            
            rerun(closure,
                  checkEvery: checkEvery,
                  maxTriesCount: maxTriesCount - 1,
                  until: until)
        }
    }
}
