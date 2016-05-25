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
    
    var player1: User?
    var player2: User?
    let ready: NSDate?
    let shotsFired: NSTimeInterval?
    var id: String?
    var timestamp: NSDate
    var endpoint: String {
        return "duels"
    }
    
    init(player1: User?, player2: User?, ready: NSDate?, shotsFired: NSTimeInterval?, timestamp: NSDate = NSDate()) {
        self.player1 = player1
        self.player2 = player2
        self.ready = ready
        self.shotsFired = shotsFired
        self.timestamp = timestamp
    }
    
    private let kPlayer1 = "player1"
    private let kPlayer2 = "player2"
    private let kReady = "ready"
    private let kShotsFired = "shotsFired"
    private let kTimestamp = "timestamp"
    
    var jsonValue: [String : AnyObject] {
        var json: [String: AnyObject] = [kTimestamp: timestamp.timeIntervalSince1970]
        if let player1 = player1 {
            json.updateValue(player1, forKey: kPlayer1)
        }
        if let player2 = player2 {
            json.updateValue(player2, forKey: kPlayer2)
        }

        if let shotsFired = shotsFired {
            json.updateValue(shotsFired, forKey: kShotsFired)
        }
        if let ready = ready {
            json.updateValue(ready, forKey: kReady)
        }
        return json
    }
    
    required init?(json:[String: AnyObject], id: String) {
        guard let timestamp = json[kTimestamp] as? NSTimeInterval else { return nil }
            self.player1 = json[kPlayer1] as? User
            self.player2 = json[kPlayer2] as? User
//            ready = json[kReady] as? NSDate,
//            shotsFired = json[kShotsFired] as? NSTimeInterval? else {return nil }
        self.id = id
//        self.player1 = player1
//        self.player2 = player2
        self.ready = json[kReady] as? NSDate
        self.shotsFired = json[kShotsFired] as? NSTimeInterval
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
    }
}

func == (lhs: Duel, rhs: Duel) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}