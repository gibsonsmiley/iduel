//
//  UserController.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreMotion
import AudioToolbox

class UserController {
    
    static var temporaryMeasurements: CMGyroData?
    var loweredMesaurements: CMGyroData?
    
    static func saveCalibration() {
        
        
    }
    
    static func beginMotionTracking() {
        let motionManager = CMMotionManager()
        
        if motionManager.gyroAvailable {
            motionManager.startGyroUpdates()
            motionManager.gyroUpdateInterval = 1.0
            let queue = NSOperationQueue.mainQueue()
            motionManager.startGyroUpdatesToQueue(queue, withHandler: { (data, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    if let data = data {
                        temporaryMeasurements = data
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                }
            })
        }
    }
}