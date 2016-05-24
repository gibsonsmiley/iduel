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
    
    static var temporaryMeasurements: CMGyroData?
    var loweredMesaurements: CMGyroData?
    static var gyroDataArray: [CMGyroData] = []
    
    static func saveCalibration(position: String, userCalibration: Calibration) {
        let moc = Stack.sharedStack.managedObjectContext
        if position == "raised" {
            guard let raisedCalibrationEntity = NSEntityDescription.entityForName("raisedCalibration", inManagedObjectContext: moc) else {return}
            let calibration = NSManagedObject(entity: raisedCalibrationEntity, insertIntoManagedObjectContext: moc)
            calibration.setValue(userCalibration.x, forKey: "x")
            calibration.setValue(userCalibration.y, forKey: "y")
            calibration.setValue(userCalibration.z, forKey: "z")
            let _ = try? moc.save()
        } else if position == "lowered" {
            guard let loweredCalibrationEntity = NSEntityDescription.entityForName("loweredCalibration", inManagedObjectContext: moc) else {return}
            let calibration = NSManagedObject(entity: loweredCalibrationEntity, insertIntoManagedObjectContext: moc)
            calibration.setValue(userCalibration.x, forKey: "x")
            calibration.setValue(userCalibration.y, forKey: "y")
            calibration.setValue(userCalibration.z, forKey: "z")
            let _ = try? moc.save()
        } else {
            // Position entered does not exist
        }
    }
    
    static func loadCalibration(position: String, completion:(calibration: Calibration?) -> Void) {
        let request = NSFetchRequest(entityName: "\(position)Calibration")
        let moc = Stack.sharedStack.managedObjectContext
        if let calibrations = try? moc.executeFetchRequest(request),
            calibration = calibrations.first {
            guard let x = calibration.valueForKey("x") as? Double,
                y = calibration.valueForKey("y") as? Double,
                z = calibration.valueForKey("z") as? Double else { completion(calibration: nil); return}
            let storedCalibration = Calibration(x: x, y: y, z: z)
            completion(calibration: storedCalibration)
        } else {
            completion(calibration: nil)
        }
    }
    
    static func trackMotionForDuel(completion: (currentPosition: Calibration?) -> Void) {
        let motionManager = CMMotionManager()
        if motionManager.gyroAvailable {
            motionManager.startGyroUpdates()
            motionManager.gyroUpdateInterval = 0.1
            let queue = NSOperationQueue.mainQueue()
            let motionQueue = dispatch_queue_create("duelTracking", nil)
            dispatch_async(motionQueue, {
                motionManager.startGyroUpdatesToQueue(queue, withHandler: { (data, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(currentPosition: nil)
                    } else {
                        guard let data = data else { completion(currentPosition: nil); return }
                        let xPosition = data.rotationRate.x
                        let yPosition = data.rotationRate.y
                        let zPosition = data.rotationRate.z
                        let currentPosition = Calibration(x: xPosition, y: yPosition, z: zPosition)
                        completion(currentPosition: currentPosition)
                    }
                })
            })
        }
    }
    
    static func playerReady(player: User, duel: Duel, currentPosition: Calibration, savedCalibration: Calibration, completion: (success: Bool) -> Void) {
        if currentPosition != savedCalibration {
            // Phone moved out of the average area of the calibration
            DuelController.playerReady(player, duel: duel)
            completion(success: true)
        } else {
            // Phone is still in average area of calibration, nothing happens
            completion(success: false)
        }
        
    }
    
    static func beginMotionTracking(completion:(averageCalibration: Calibration?) -> Void) {
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
                        print(error?.localizedDescription)
                        completion(averageCalibration: nil)
                    } else {
                        guard let data = data else { completion(averageCalibration: nil); return }
                        self.gyroDataArray.append(data)
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                })
            })
            
            //set up background queue to count to 5, stops observing gyro data after 5 seconds
            let backgroundQueue = dispatch_queue_create("", nil)
            dispatch_async(backgroundQueue, {
                NSThread.sleepForTimeInterval(5.0)
                motionManager.stopGyroUpdates()
                //                print(self.gyroDataArray[0].rotationRate.x)
                //                print(self.gyroDataArray[0])
                let x = (self.gyroDataArray[0].rotationRate.x + self.gyroDataArray[1].rotationRate.x + self.gyroDataArray[2].rotationRate.x + self.gyroDataArray[3].rotationRate.x + self.gyroDataArray[4].rotationRate.x) / 5
                let y = (self.gyroDataArray[0].rotationRate.y + self.gyroDataArray[1].rotationRate.y + self.gyroDataArray[2].rotationRate.y + self.gyroDataArray[3].rotationRate.y + self.gyroDataArray[4].rotationRate.y) / 5
                let z = (self.gyroDataArray[0].rotationRate.z + self.gyroDataArray[1].rotationRate.z + self.gyroDataArray[2].rotationRate.z + self.gyroDataArray[3].rotationRate.z + self.gyroDataArray[4].rotationRate.z) / 5
                let average = Calibration(x: x, y: y, z: z)
                print("Average: \(average)")
                completion(averageCalibration: average)
            })
        } else {
            completion(averageCalibration: nil)
        }
    }
    
    static func checkCalibration(calibratedAverage: Calibration, currentMeasurements: Calibration, completion: (success: Bool) -> Void) {
        if (Double(currentMeasurements.x!) < (Double(calibratedAverage.x!) + 1.0) && Double(currentMeasurements.x!) > (Double(calibratedAverage.x!) - 1.0)) && (Double(currentMeasurements.y!) < (Double(calibratedAverage.y!) + 1.0) && Double(currentMeasurements.y!) > (Double(calibratedAverage.y!) - 1.0)) && (Double(currentMeasurements.z!) < (Double(calibratedAverage.z!) + 1.0) && Double(currentMeasurements.z!) > (Double(calibratedAverage.z!) - 1.0)) {
            completion(success: true)
        } else {
            completion(success: false)
        }
    }
}