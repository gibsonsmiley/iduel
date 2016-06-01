//
//  MotionController.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreMotion
import AudioToolbox
import CoreData

class MotionController {
    
    static let sharedController = MotionController()
    var motionManager: CMMotionManager!
    
    init() {
        self.motionManager = CMMotionManager()
    }
    
    func checkFlick(completion:(success: Bool) -> Void) {
        if self.motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.25
            
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (motion, error) in
                if error != nil {
                    completion(success: false)
                } else {
                    if let motion = motion {
                        if motion.userAcceleration.x > 0.09 {
                            completion(success: true)
                        } else {
                            completion(success: false)
                        }
                    }
                }
            })
        }
    }
    
    func checkRange(raised: Bool, completion:(success: Bool) -> Void) {
        if self.motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.10
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (motion, error) in
                if error != nil {
                    completion(success: false)
                } else {
                    if let motion = motion {
                        if raised {
                            if motion.attitude.pitch < 0.38 && motion.attitude.pitch > -0.30 {
                                completion(success: true)
                            } else {
                                completion(success: false)
                            }
                        } else {
                            if motion.attitude.pitch < -0.90 {
                                completion(success: true)
                            } else {
                                completion(success: false)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func beginMotionTracking(completion: (currentPosition: CMDeviceMotion?, raised: Bool, lowered: Bool) -> Void) {
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (motion, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(currentPosition: nil, raised: false, lowered: false)
                } else {
                    guard let motion = motion else { completion(currentPosition: nil, raised: false, lowered: false); return }
                    if motion.attitude.pitch < 0.38 && motion.attitude.pitch > -0.3 {
                        completion(currentPosition: motion, raised: true, lowered: false)
                    } else if motion.attitude.pitch < -0.8 {
                        completion(currentPosition: motion, raised: false, lowered: true)
                    } else {
                        completion(currentPosition: motion, raised: false, lowered: false)
                    }
                }
            })
        } else {
            // device motion is unavailable
        }
    }
}