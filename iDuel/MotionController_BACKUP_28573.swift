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
    
    
     func saveCalibration(position: String, userCalibration: Calibration) {
        let moc = Stack.sharedStack.managedObjectContext
        if position == "raised" {
<<<<<<< HEAD
            guard let raisedCalibrationEntity = NSEntityDescription.entityForName("raisedCalibration", inManagedObjectContext: moc) else {return}
            let calibration = NSManagedObject(entity: raisedCalibrationEntity, insertIntoManagedObjectContext: moc)
            calibration.setValue(userCalibration.x, forKey: "x")
            calibration.setValue(userCalibration.y, forKey: "y")
            calibration.setValue(userCalibration.z, forKey: "z")
            let _ = try? moc.save()
=======
        guard let raisedCalibrationEntity = NSEntityDescription.entityForName("raisedCalibration", inManagedObjectContext: moc) else {return}
        let calibration = NSManagedObject(entity: raisedCalibrationEntity, insertIntoManagedObjectContext: moc)
        calibration.setValue(userCalibration.pitch, forKey: "pitch")
        calibration.setValue(userCalibration.roll, forKey: "roll")
        calibration.setValue(userCalibration.yaw, forKey: "yaw")
        let _ = try? moc.save()
>>>>>>> 36a0958f29b3960526506ade3b90575b4e9e2ab5
        } else if position == "lowered" {
            guard let loweredCalibrationEntity = NSEntityDescription.entityForName("loweredCalibration", inManagedObjectContext: moc) else {return}
            let calibration = NSManagedObject(entity: loweredCalibrationEntity, insertIntoManagedObjectContext: moc)
            calibration.setValue(userCalibration.pitch, forKey: "pitch")
            calibration.setValue(userCalibration.roll, forKey: "roll")
            calibration.setValue(userCalibration.yaw, forKey: "yaw")
            let _ = try? moc.save()
        } else {
            // Position entered does not exist
        }
    }
    
<<<<<<< HEAD
    static func loadCalibration(position: String, completion:(calibration: Calibration?) -> Void) {
        let request = NSFetchRequest(entityName: "\(position)Calibration")
=======
     func loadCalibration(position: String, completion:(calibration: Calibration?) -> Void) {
        let request = NSFetchRequest(entityName: "\(position)calibration")
>>>>>>> 36a0958f29b3960526506ade3b90575b4e9e2ab5
        let moc = Stack.sharedStack.managedObjectContext
        if let calibrations = try? moc.executeFetchRequest(request),
            calibration = calibrations.first {
            guard let pitch = calibration.valueForKey("pitch") as? Double,
                roll = calibration.valueForKey("roll") as? Double,
                yaw = calibration.valueForKey("yaw") as? Double else { completion(calibration: nil); return}
            let storedCalibration = Calibration(pitch: pitch, roll: roll, yaw: yaw)
            completion(calibration: storedCalibration)
        } else {
            completion(calibration: nil)
        }
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
    
     func playerReady(player: User, duel: Duel, currentPosition: Calibration, savedCalibration: Calibration, completion: (success: Bool) -> Void) {
        if currentPosition != savedCalibration {
            // Phone moved out of the average area of the calibration
            DuelController.playerReady(player, duel: duel)
            completion(success: true)
        } else {
            // Phone is still in average area of calibration, nothing happens
            completion(success: false)
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
<<<<<<< HEAD
                motionManager.stopGyroUpdates()
                //                print(self.gyroDataArray[0].rotationRate.x)
                //                print(self.gyroDataArray[0])
                let x = (self.gyroDataArray[0].rotationRate.x + self.gyroDataArray[1].rotationRate.x + self.gyroDataArray[2].rotationRate.x + self.gyroDataArray[3].rotationRate.x + self.gyroDataArray[4].rotationRate.x) / 5
                let y = (self.gyroDataArray[0].rotationRate.y + self.gyroDataArray[1].rotationRate.y + self.gyroDataArray[2].rotationRate.y + self.gyroDataArray[3].rotationRate.y + self.gyroDataArray[4].rotationRate.y) / 5
                let z = (self.gyroDataArray[0].rotationRate.z + self.gyroDataArray[1].rotationRate.z + self.gyroDataArray[2].rotationRate.z + self.gyroDataArray[3].rotationRate.z + self.gyroDataArray[4].rotationRate.z) / 5
                let average = Calibration(x: x, y: y, z: z)
                print("Average: \(average)")
=======
                self.motionManager.stopDeviceMotionUpdates()
                print(self.PitchRollYawArray[0])
                print(self.PitchRollYawArray[0])
                let pitch = (self.PitchRollYawArray[0].attitude.pitch + self.PitchRollYawArray[1].attitude.pitch + self.PitchRollYawArray[2].attitude.pitch + self.PitchRollYawArray[3].attitude.pitch + self.PitchRollYawArray[4].attitude.pitch) / 5
                let roll = (self.PitchRollYawArray[0].attitude.roll + self.PitchRollYawArray[1].attitude.roll + self.PitchRollYawArray[2].attitude.roll + self.PitchRollYawArray[3].attitude.roll + self.PitchRollYawArray[4].attitude.roll) / 5
                let yaw = (self.PitchRollYawArray[0].attitude.yaw + self.PitchRollYawArray[1].attitude.yaw + self.PitchRollYawArray[2].attitude.yaw + self.PitchRollYawArray[3].attitude.yaw + self.PitchRollYawArray[4].attitude.yaw) / 5
                let average = Calibration(pitch: pitch, roll: roll, yaw: yaw)
>>>>>>> 36a0958f29b3960526506ade3b90575b4e9e2ab5
                completion(averageCalibration: average)
            })
        } else {
            completion(averageCalibration: nil)
        }
    }
    
     func checkCalibration(calibratedAverage: Calibration, currentMeasurements: Calibration, completion: (success: Bool) -> Void) {
        if (Double(currentMeasurements.pitch!) < (Double(calibratedAverage.pitch!) + 1.0) && Double(currentMeasurements.pitch!) > (Double(calibratedAverage.pitch!) - 1.0)) && (Double(currentMeasurements.roll!) < (Double(calibratedAverage.roll!) + 1.0) && Double(currentMeasurements.roll!) > (Double(calibratedAverage.roll!) - 1.0)) && (Double(currentMeasurements.yaw!) < (Double(calibratedAverage.yaw!) + 1.0) && Double(currentMeasurements.yaw!) > (Double(calibratedAverage.yaw!) - 1.0)) {
            completion(success: true)
        } else {
            completion(success: false)
        }
    }
}