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
    
    
}