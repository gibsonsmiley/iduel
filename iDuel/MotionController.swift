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

class MotionController {
    
    static var temporaryMeasurements: CMGyroData?
    var loweredMesaurements: CMGyroData?
    static var gyroDataArray: [CMGyroData] = []
    
    static func saveCalibration() {
        
        
    }
    
    static func beginMotionTracking(completion:(averageCalibration: CMRotationRate?) -> Void) {
        let motionManager = CMMotionManager()
        if motionManager.gyroAvailable {
            motionManager.startGyroUpdates()
            motionManager.gyroUpdateInterval = 1.0
            let queue = NSOperationQueue.mainQueue()
            let motionQueue = dispatch_queue_create("", nil)
            
            //gathers CMGyroData every second
            dispatch_async(motionQueue, {
                motionManager.startGyroUpdatesToQueue(queue, withHandler: { (data, error) in
                    if error != nil {
                        print(error)
                        completion(averageCalibration: nil)
                    }
                    if let data = data {
                        self.gyroDataArray.append(data)
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    } else {
                        completion(averageCalibration: nil)
                    }
                })
            })
            
            //set up background queue to count to 5, stops observing gyro data after 5 seconds
            let backgroundQueue = dispatch_queue_create("", nil)
            dispatch_async(backgroundQueue, {
                NSThread.sleepForTimeInterval(5.0)
                motionManager.stopGyroUpdates()
                print(self.gyroDataArray[0].rotationRate.x)
                print(self.gyroDataArray[0])
                let x = (self.gyroDataArray[0].rotationRate.x + self.gyroDataArray[1].rotationRate.x + self.gyroDataArray[2].rotationRate.x + self.gyroDataArray[3].rotationRate.x + self.gyroDataArray[4].rotationRate.x) / 5
                let y = (self.gyroDataArray[0].rotationRate.y + self.gyroDataArray[1].rotationRate.y + self.gyroDataArray[2].rotationRate.y + self.gyroDataArray[3].rotationRate.y + self.gyroDataArray[4].rotationRate.y) / 5
                let z = (self.gyroDataArray[0].rotationRate.z + self.gyroDataArray[1].rotationRate.z + self.gyroDataArray[2].rotationRate.z + self.gyroDataArray[3].rotationRate.z + self.gyroDataArray[4].rotationRate.z) / 5
                let average = CMRotationRate(x: x, y: y, z: z)
                completion(averageCalibration: average)
            })
        } else {
            completion(averageCalibration: nil)
        }
    }
    
    static func checkCalibration(calibratedAverage: CMRotationRate, currentMeasurements: CMRotationRate, completion: (success: Bool) -> Void) {
        if (currentMeasurements.x < (calibratedAverage.x + 1.0) && currentMeasurements.x > (calibratedAverage.x - 1.0)) && (currentMeasurements.y < (calibratedAverage.y + 1.0) && currentMeasurements.y > (calibratedAverage.y - 1.0)) && (currentMeasurements.z < (calibratedAverage.z + 1.0) && currentMeasurements.z > (calibratedAverage.z - 1.0)) {
            completion(success: true)
        } else {
            completion(success: false)
        }
    }
    
}