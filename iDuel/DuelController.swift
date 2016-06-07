//
//  DuelController.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreMotion
import AudioToolbox

class DuelController {
    
    static let sharedController = DuelController()
    var player1: User?
    var player2: User?
    
    // Method to add player to duel's ready array, this is the gun cock
    // This is appending data to the firebase ready array under the user's id
    static func playerReady(user: User, duel: Duel, completion:(success: Bool) -> Void) {
        guard let userID = user.id else { completion(success: false); return }
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/status").setValue("\(userID)")
        completion(success: true)
    }
    
    static func duelStart(duel: Duel?, completion:(duel: Duel?, success: Bool) -> Void) {
        // User points phone down by waist, checks to see if the device is in range
        MotionController.sharedController.checkRange(false) { (success) in
            if success {
                print("Device at waist")
                MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                NSThread.sleepForTimeInterval(0.5)
                
                //User flicks phone to show they are ready for the duel to begin
                MotionController.sharedController.checkFlick({ (success) in
                    if success {
                        print("Flick successful")
                        MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                        SystemSoundID.playGunCocking("GunCocking", withExtenstion: "mp3")
                        
                        // check to see if there is a duel
                        if let duel = duel {
                            DuelController2.sendStatusToDuel(UserController.sharedController.currentUser, duel: duel, completion: { (success) in
                                if success {
                                    completion(duel: duel, success: true)
                                } else {
                                    print("player 1 and player 2 not ready")
                                }
                            })
                        } else {
                            print("duel not ready")
                            
                        }
                    } else {
                        print("No flick detected")
                    }
                })
            } else {
                print("Device is not in range")
            }
        }
    }
}