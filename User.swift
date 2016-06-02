//
//  User.swift
//  Duellum
//
//  Created by mac-admin on 5/18/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreMotion


class User: Equatable, FirebaseType {
    
    
    private let kNickname = "nickname"
    private let kDuelIDs = "duelIDs"
    private let kTimestamp = "timestamp"
    
    var nickname: String
    var duelIDs: [String]? = [] {
        didSet {
            UserController.sharedController.currentUser.save()
        }
    }
    var timestamp: NSDate
    var id: String?
    var endpoint: String {
        return "users"
    }
    
    init(nickname: String, duelIDs: [String]? = [], timestamp: NSDate = NSDate()) {
        self.nickname = nickname
        self.duelIDs = duelIDs
        self.timestamp = timestamp
    }
    
    var jsonValue: [String : AnyObject] {
        var json: [String: AnyObject] = [kNickname: nickname, kTimestamp: timestamp.timeIntervalSince1970]
        if let duelIDs = duelIDs {
            json.updateValue(duelIDs, forKey: kDuelIDs)
        }
        return json
    }
    
    required init?(json: [String: AnyObject], id: String) {
        guard let nickname = json[kNickname] as? String,
            timestamp = json[kTimestamp] as? NSTimeInterval else { return nil }
        self.id = id
        self.nickname = nickname
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        if let duelIDs = json[kDuelIDs] as? [String] {
            self.duelIDs = duelIDs
        }
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

extension NSDate {
    func equalToDate(dateToCompare: NSDate) -> Bool {
        var isEqualTo = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        return isEqualTo
    }
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        var isGreater = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        var isLess = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        return isLess
    }
}
