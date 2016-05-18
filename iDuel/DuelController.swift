//
//  DuelController.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

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
    static func playerReady() {
        
    }
    
    // Checks to see if both players are ready. If so, call start duel method
    static func checkReadyStatus(player1Ready: Bool, player2Ready: Bool, completion: (playersReady: Bool) -> Void) {
        
    }
    
    // Calls the countdown method, then the check fire method, then the victory method
    static func startDuel() {
        
    }
    
    // Determines who was the winner and loser and displays the appropriate response to both
    static func victory(firstShot: User, completion: (winner: User, loser: User) -> Void) {
        
    }
    
    // Observes firebase as the duel/\(id)/shotsFired, to observe who shot first
    static func checkFire(completion: (firstShot: User) -> Void) {
        
    }
    
    // Randomally generates a waiting period before initializing a vibration on each phone to show the duel has started
    static func countDown(completion: (countdownInt: Int) -> Void) {
        
    }
    
    // recognizes user's button tap and sends a value to Firebase
    static func fire() {
        
    }
}