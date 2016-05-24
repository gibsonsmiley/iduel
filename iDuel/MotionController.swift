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
    
    static var temporaryMeasurements: CMGyroData?
    var loweredMesaurements: CMGyroData?
    
    // pitch = rotation around the x axis
    // roll = rotation around the y axis
    // yaw = rotation around the z axis
    var PitchRollYawArray: [CMDeviceMotion] = []

    var motionManager: CMMotionManager!
    
    init() {
        self.motionManager = CMMotionManager()
    }
    
    
        
     func trackMotionForDuel(completion: (currentPosition: Calibration?) -> Void) {
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            let queue = NSOperationQueue.mainQueue()
            let motionQueue = dispatch_queue_create("duelTracking", nil)
            dispatch_async(motionQueue, {
                self.motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(currentPosition: nil)
                    } else {
                        guard let data = data else { completion(currentPosition: nil); return }
                        let pitch = data.attitude.pitch
                        let roll = data.attitude.roll
                        let yaw = data.attitude.yaw
                        let currentPosition = Calibration(pitch: pitch, roll: roll, yaw: yaw)
                        completion(currentPosition: currentPosition)
                    }
                })
            })
        }
    }
    
   
    
     func beginMotionTracking(completion:(averageCalibration: Calibration?) -> Void) {

        if motionManager.deviceMotionAvailable {
            motionManager.startDeviceMotionUpdates()
            motionManager.gyroUpdateInterval = 1.0
            let queue = NSOperationQueue.mainQueue()
            let motionQueue = dispatch_queue_create("", nil)
            
            //gathers CMGyroData every second
            dispatch_async(motionQueue, {
                self.motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        completion(averageCalibration: nil)
                    } else {
                        guard let data = data else { completion(averageCalibration: nil); return }
                        self.PitchRollYawArray.append(data)
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                })
            })
            
            //set up background queue to count to 5, stops observing gyro data after 5 seconds
            let backgroundQueue = dispatch_queue_create("", nil)
            dispatch_async(backgroundQueue, {
                NSThread.sleepForTimeInterval(5.0)
                self.motionManager.stopDeviceMotionUpdates()
                print(self.PitchRollYawArray[0])
                print(self.PitchRollYawArray[0])
                let pitch = (self.PitchRollYawArray[0].attitude.pitch + self.PitchRollYawArray[1].attitude.pitch + self.PitchRollYawArray[2].attitude.pitch + self.PitchRollYawArray[3].attitude.pitch + self.PitchRollYawArray[4].attitude.pitch) / 5
                let roll = (self.PitchRollYawArray[0].attitude.roll + self.PitchRollYawArray[1].attitude.roll + self.PitchRollYawArray[2].attitude.roll + self.PitchRollYawArray[3].attitude.roll + self.PitchRollYawArray[4].attitude.roll) / 5
                let yaw = (self.PitchRollYawArray[0].attitude.yaw + self.PitchRollYawArray[1].attitude.yaw + self.PitchRollYawArray[2].attitude.yaw + self.PitchRollYawArray[3].attitude.yaw + self.PitchRollYawArray[4].attitude.yaw) / 5
                let average = Calibration(pitch: pitch, roll: roll, yaw: yaw)
                completion(averageCalibration: average)
            })
        } else {
            completion(averageCalibration: nil)
        }
    }
    
    func checkFlick(completion:(success: Bool) -> Void) {
        motionManager = CMMotionManager()
        if self.motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.25
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (motion, error) in
                if error != nil {
                    completion(success: false)
                } else {
                    
                    if let motion = motion {
                        if motion.userAcceleration.x > 0.069 {
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
        motionManager = CMMotionManager()
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
                            if motion.attitude.pitch < -0.80 {
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

    }