//
//  Duel.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class Duel: Equatable, FirebaseType {
    
    // MARK: - "ready" and "shotsFired" properties aren't going to work
    
    let player1: User
    let player2: User
    let ready: NSDate?
    let shotsFired: NSTimeInterval?
    var id: String?
    var endpoint: String {
        return "duel"
    }
    
    init(player1: User?, player2: User?, ready: NSDate?, shotsFired: NSTimeInterval? ) {
        if let player1 = player1 {
            self.player1 = player1
        }
        if let player2 = player2 {
            self.player2 = player2
        }
        self.ready = ready
        self.shotsFired = shotsFired
    }
    
    private let kPlayer1 = "player1"
    private let kPlayer2 = "player2"
    private let kReady = "ready"
    private let kShotsFired = "shotsFired"
    
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
        guard let player1 = json[kPlayer1] as? User,
            player2 = json[kPlayer2] as? User,
            ready = json[kReady] as? NSDate,
            shotsFired = json[kShotsFired] as? NSTimeInterval? else {return nil }
        self.id = id
        self.player1 = player1
        self.player2 = player2
        self.ready = ready
        self.shotsFired = shotsFired
    }
}

func == (lhs: Duel, rhs: Duel) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}