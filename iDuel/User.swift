//
//  User.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreMotion

class User: Equatable, FirebaseType {
    
    let nickname: String
    var flick: CMRotationRate?
    var currentPosition: CMRotationRate?
    var calibrationLowered: CMRotationRate?
    var calibrationRaised: CMRotationRate?
    var duelIDs: [String]? = []
    let timestamp: NSDate
    var id: String?
    var endpoint: String {
        return "users"
    }
    
    init(nickname: String, flick: CMRotationRate? = nil, currentPosition: CMRotationRate? = nil, calibrationLowered: CMRotationRate? = nil, calibrationRaised: CMRotationRate? = nil, duelIDs:[String]? = [], id: String? = nil, timestamp: NSDate = NSDate()) {
        self.nickname = nickname
        self.flick = flick
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
        self.duelIDs = duelIDs
        self.timestamp = timestamp
    }
    
    private let kNickname = "nickname"
    private let kCurrentPosition = "currentPosition"
    private let kCalibrationLowered = "calibrationLowered"
    private let kCalibrationRaised = "calibrationRaised"
    private let kDuelIDs = "duelIDs"
    private let kTimestamp = "timestamp"
    
    var jsonValue: [String : AnyObject] {
        var json: [String: AnyObject] = [kNickname: nickname, kTimestamp: timestamp]
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
        self.currentPosition = json[kCurrentPosition] as? CMRotationRate
        self.calibrationLowered = json[kCalibrationLowered] as? CMRotationRate
        self.calibrationRaised = json[kCalibrationRaised] as? CMRotationRate
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        if let duelIDs = json[kDuelIDs] as? [String] {
            self.duelIDs = duelIDs
        }
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}