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
    
    // Self explanitory
    static func createDuel(player1: User?, player2: User?, completion: (success: Bool, duel: Duel?) -> Void) {
        guard let currentUser = UserController.sharedController.currentUser else { completion(success: false, duel: nil); return }
        guard let player1 = player1 else { return }
        var duel = Duel(challengerID: player1.id!, opponentID: player2!.id!, statuses: nil, shotsFired: nil)
        guard let duelID = duel.id else { completion(success: false, duel: nil); return }
        duel.save()
        completion(success: true, duel: duel)
        currentUser.duelIDs?.append(duelID)
        //        currentUser.save()
        //        player2.duelIDs?.append(duelID)
        //        player2.save()
    }
    
    static func deleteDuel(duel: Duel, completion: (success: Bool) -> Void) {
        duel.delete()
        guard let duelID = duel.id else { completion(success: false); return }
        fetchDuelForID(duelID) { (duel) in
            completion(success: true)
        }
    }
    
    static func fetchDuelForID(id: String, completion: (duel: Duel?) -> Void) {
        FirebaseController.dataAtEndpoint("duels/\(id)") { (data) in
            guard let json = data as? [String: AnyObject] else { completion(duel: nil); return }
            let duel = Duel(json: json, id: id)
            completion(duel: duel)
        }
    }
    
    static func fetchAllDuels(completion: (duels: [Duel]?) -> Void) {
        FirebaseController.dataAtEndpoint("duels") { (data) in
            guard let json = data as? [String: AnyObject] else { completion(duels: nil); return }
            let duels = json.flatMap({Duel(json: $0.1 as! [String: AnyObject], id: $0.0)})
            completion(duels: duels)
        }
    }
    
    static func observePlayersForDuel(duel: Duel, completion: (players: [User]?) -> Void) {
        // May use this
    }
    
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
    
    // Observes firebase as the duel/\(id)/shotsFired, to observe who shot first // victory function seems to cover anything this function would need to do
    static func checkFire(completion: (firstShot: User) -> Void) {
        
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
    
    
    
    static func duelStart(duel: Duel?, completion:(success: Bool) -> Void) {
        // User points phone down by waist, checks to see if the device is in range
        MotionController.sharedController.checkRange(false) { (success) in
            if success {
                print("device at waist")
                MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                NSThread.sleepForTimeInterval(0.5)
                
                //User flicks phone to show they are ready for the duel to begin
                MotionController.sharedController.checkFlick({ (success) in
                    if success {
                        print("flick successful")
                        MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                        SystemSoundID.playGunCocking("GunCocking", withExtenstion: "mp3")
                        
                        // check to see if there is a duel
                        if let duel = duel {
                            
                            // check to see if the players are ready
                            DuelController.playerReady(UserController.sharedController.currentUser, duel: duel, completion: { (success) in
                                if success {
                                    //                                    UserController.fetchUserForIdentifier(duel.challengerID, completion: { (user) in
                                    //                                        guard let user = user else { return }
                                    //                                        sharedController.player1 = user
                                    //                                    })
                                    //                                    UserController.fetchUserForIdentifier(duel.opponentID!, completion: { (user) in
                                    //                                        guard let user = user else { return }
                                    //                                        sharedController.player2 = user
                                    //                                    })
                                    //                                    guard let player1 = sharedController.player1,
                                    //                                        player2 = sharedController.player2 else {return}
                                    
                                    // Send ready status up to firebase
                                    DuelController2.sendStatusToDuel(UserController.sharedController.currentUser, duel: duel, completion: { (success) in
                                        if success {
                                            
                                            // Send time between 2 and 4 seconds up to firebase
                                            DuelController2.sendCountdownToDuel(duel, completion: { (success) in
                                                if success {
                                                    
                                                    // Countdown starts
                                                    DuelController2.observeCountdown(duel, completion: { (countdown) in
                                                        if let countdown = countdown {
                                                            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), countdown)
                                                            dispatch_after(time, dispatch_get_main_queue(), {
                                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                                                                
                                                                // User raises device, checks to see if in the correct range
                                                                MotionController.sharedController.checkRange(true, completion: { (success) in
                                                                    if success {
                                                                        MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                                                                        completion(success: true)
                                                                    } else {
                                                                        print("gun not in range to shoot")
                                                                    }
                                                                })
                                                            })
                                                        } else {
                                                            print("countdown nil")
                                                        }
                                                    })
                                                } else {
                                                    print("countdown not sent")
                                                }
                                            })
                                        } else {
                                            print("player 1 and player 2 not ready")
                                            
                                        }
                                    })
                                } else {
                                    print("player not ready")
                                    
                                }
                                
                            })
                        } else {
                            print("duel not ready")
                            
                        }
                    } else {
                        print("flick no successful")
                        
                    }
                })
            } else {
                print("device is not in range")
            }
        }
    }
}