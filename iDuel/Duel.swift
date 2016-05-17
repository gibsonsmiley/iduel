//
//  Duel.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class Duel: Equatable, FirebaseType {
    
    let player1: String
    let player2: String
    let score: (Int, Int)?
    let ready: NSDate?
    let shotsFired: NSTimeInterval?
    var id: String?
    var endpoint: String {
        return "duel"
    }
    
    init(player1: String, player2: String, score:(Int, Int)?, ready: NSDate?, shotsFired: NSTimeInterval? ) {
        self.player1 = player1
        self.player2 = player2
        self.ready = ready
        self.shotsFired = shotsFired
        self.score = score
    }
    
    private let kPlayer1 = "player1"
    private let kPlayer2 = "player2"
    private let kReady = "ready"
    private let kShotsFired = "shotsFired"
    private let kScore = "score"
    
    var jsonValue: [String : AnyObject] {
        var json: [String: AnyObject] = [kPlayer1: player1, kPlayer2: player2]
        if let shotsFired = shotsFired {
            json.updateValue(shotsFired, forKey: kShotsFired)
        }
        if let ready = ready {
            json.updateValue(ready, forKey: kReady)
        }
        return json
    }
    
    required init?(json:[String: AnyObject], id: String) {
        guard let player1 = json[kPlayer1] as? String,
            player2 = json[kPlayer2] as? String,
            ready = json[kReady] as? NSDate,
            shotsFired = json[kShotsFired] as? NSTimeInterval?,
            score = json[kScore] as? (Int, Int) else {return nil }
        self.id = id
        self.score = score
        self.player1 = player1
        self.player2 = player2
        self.ready = ready
        self.shotsFired = shotsFired
    }
}

func == (lhs: Duel, rhs: Duel) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}