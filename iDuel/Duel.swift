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
    
    var challengerID: String
    var opponentID: String?
    let statuses: [String]?
    let shotsFired: [String]?
    var id: String?
    var timestamp: NSDate
    var endpoint: String {
        return "duels"
    }
    
    init(challengerID: String, opponentID: String?, statuses: [String]?, shotsFired: [String]?, timestamp: NSDate = NSDate()) {
        self.challengerID = challengerID
        self.opponentID = opponentID
        self.statuses = statuses
        self.shotsFired = shotsFired
        self.timestamp = timestamp
    }
    
    private let kChallengerID = "challengerID"
    private let kOpponentID = "opponentID"
    private let kStatuses = "statuses"
    private let kShotsFired = "shotsFired"
    private let kTimestamp = "timestamp"
    
    var jsonValue: [String : AnyObject] {
        var json: [String: AnyObject] = [kTimestamp: timestamp.timeIntervalSince1970, kChallengerID: challengerID]
        if let opponentID = opponentID {
            json.updateValue(opponentID, forKey: kOpponentID)
        }
        
        if let shotsFired = shotsFired {
            json.updateValue(shotsFired, forKey: kShotsFired)
        }
        if let statuses = statuses {
            json.updateValue(statuses, forKey: kStatuses)
        }
        return json
    }
    
    required init?(json:[String: AnyObject], id: String) {
        guard let timestamp = json[kTimestamp] as? NSTimeInterval,
            let challengerID = json[kChallengerID] as? String else { return nil }
        self.id = id
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        self.challengerID = challengerID
        if let opponentID = json[kOpponentID] as? String {
            self.opponentID = opponentID
        }
        if let statuses = json[kStatuses] as? [String] {
            self.statuses = statuses
        } else {
            self.statuses = []
        }
        if let shotsFired = json[kShotsFired] as? [String] {
            self.shotsFired = shotsFired
        } else {
            self.shotsFired = []
        }
    }
    
    static func volumeChanged(notification: NSNotification) {
        
     
    }
}

func == (lhs: Duel, rhs: Duel) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}