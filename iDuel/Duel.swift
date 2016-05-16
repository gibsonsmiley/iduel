//
//  Duel.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class Duel {
    
    private let kPlayer1 = "player1"
    private let kPlayer2 = "player2"
    private let kDuelStart = "duelStart"
    private let kFiredTime = "firedTime"
    
    let player1: String
    let player2: String
    let score: (Int, Int)
    let duelStart: NSDate
    let firedTime: NSDate
    
    init(player1: String, player2: String, score:(Int, Int), duelStart: NSDate, firedTime: NSDate) {
        self.player1 = player1
        self.player2 = player2
        self.duelStart = duelStart
        self.firedTime = firedTime
        self.score = score
        
    }
    
    
  required init?(json:[String: AnyObject]) {
        guard let player1 = json[kPlayer1] as? String,
            player2 = json[kPlayer2] as? String,
            duelStart = json[kDuelStart] as? NSDate,
            firedTime = json[kFiredTime] as? NSDate else {return nil }
        self.player1 = player1
        self.player2 = player2
        self.duelStart = duelStart
        self.firedTime = firedTime
        
    
    }
}