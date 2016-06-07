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
    
    // Checks to see if both players are ready. If so, call start duel method
    static func checkReadyStatus(duel: Duel, player1: User, player2: User, completion: (player1Ready: Bool, player2Ready: Bool) -> Void) {
        guard let duelID = duel.id else { completion(player1Ready: false, player2Ready: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/status").observeEventType(.Value, withBlock: { (snapshot) in
            guard let statuses = snapshot.value as? [String] else { completion(player1Ready: false, player2Ready: false); return }
            guard let player1ID = player1.id else { completion(player1Ready: false, player2Ready: false); return }
            guard let player2ID = player2.id else { completion(player1Ready: false, player2Ready: false); return }
            if statuses.count == 2 {
                completion(player1Ready: true, player2Ready: true)
            } else {
                
                // One or neither player is ready
                for status in statuses {
                    if status == player1ID {
                        completion(player1Ready: true, player2Ready: false)
                    } else if status == player2ID {
                        completion(player1Ready: false, player2Ready: true)
                    } else {
                        completion(player1Ready: false, player2Ready: false)
                    }
                }
            }
        })
    }
    
    
    
    // recognizes user's button tap and sends a value to Firebase
    static func fire(duel: Duel, user: User) {
        guard let duelID = duel.id else { return }
        guard let userID = user.id else { return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/shotsFired").setValue("\(userID)")
    }
    
    // Determines who was the winner and loser and displays the appropriate response to both
    static func victory(duel : Duel, completion: (winner: User, loser: User) -> Void) {
        guard let duelID = duel.id else { return }
        FirebaseController.observeDataAtEndpoint("duels/\(duelID)/shotsFired") { (data) in
            guard let shotsFired = data as? [String] else { return }
            for ID in shotsFired {
                UserController.fetchUserForIdentifier(ID, completion: { (user) in
                    var users: [User] = []
                    guard let user = user else { return }
                    users.append(user)
                    guard let winner = users.first else { return }
                    guard let loser = users.last else { return }
                    completion(winner: winner, loser: loser)
                })
            }
        }
    }
    
    // Randomally generates a waiting period
    static func countdown(duel: Duel, completion: (countdown: UInt32) -> Void) {
        let countdownInt = arc4random_uniform(2) + 2 // This gives a random numbers between 2 and 4
        guard let duelID = duel.id else { return }
        let countdownNum = NSNumber(unsignedInt: countdownInt)
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/countdown").setValue(countdownNum)
        completion(countdown: countdownInt)
    }
    
    // Observes countdown and holds all methods for that time, then vibrates player's phones
    static func waitForCountdown(duel: Duel, completion:(success: Bool) -> Void) {
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.observeDataAtEndpoint("duels/\(duelID)/countdown") { (data) in
            if let countdown = data as? Int64 {
                
                //else { completion(success: false); return }
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), countdown)
                dispatch_after(time, dispatch_get_main_queue(), {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) // May need to exit or invalidate this: http://stackoverflow.com/a/25120393/3681880
                    completion(success: true)
                })
            } else {
                completion(success: false)
                return
            }
        }
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