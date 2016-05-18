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
    
    // Self explanitory
    static func createDuel(player1: User, player2: User, completion: (success: Bool, duel: Duel?) -> Void) {
        guard let currentUser = UserController.currentUser else { completion(success: false, duel: nil); return }
        var duel = Duel(player1: currentUser, player2: player2, score: nil, ready: nil, shotsFired: nil)
        guard let duelID = duel.id else { completion(success: false, duel: nil); return }
        duel.save()
        completion(success: true, duel: duel)
        currentUser.duelIDs?.append(duelID)
//        currentUser.save()
        player2.duelIDs?.append(duelID)
//        player2.save()
    }
    
    // Method to add player to duel's ready array, this is the gun cock
    // This is appending data to the firebase ready array under the user's id
    static func playerReady(user: User, duel: Duel/*, usersCock: CMRotationRate?*/) {
//        guard let usersCock = usersCock else { return } // I don't think this is actually necessary, motion controller should be dealing with all things motion
        guard let userID = user.id else { return }
        guard let duelID = duel.id else { return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/status").setValue("\(userID)")
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
    
    // This method should only be called if the checkReadyStatus returns two "true" bools
    // Calls the wait for countdown method, then the check fire method, then the victory method
    static func startDuel(duel: Duel) {
        guard let duelID = duel.id else { return }
        FirebaseController.dataAtEndpoint("duels/\(duelID)/countdown", completion: <#T##(data: AnyObject?) -> Void#>)
    }
    
    // Determines who was the winner and loser and displays the appropriate response to both
    static func victory(duel : Duel, firstShot: User, completion: (winner: User, loser: User) -> Void) {
        
    }
    
    // Observes firebase as the duel/\(id)/shotsFired, to observe who shot first
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
    static func waitForCountdown(duel: Duel) {
        guard let duelID = duel.id else { return }
        FirebaseController.observeDataAtEndpoint("duels/\(duelID)/countdown") { (data) in
            guard let countdown = data as? Int64 else { return }
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), countdown)
            dispatch_after(time, dispatch_get_main_queue(), {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) // May need to exit or invalidate this: http://stackoverflow.com/a/25120393/3681880
            })
        }
    }
    
    // recognizes user's button tap and sends a value to Firebase
    static func fire(duel: Duel, user: User) {
        
    }
}