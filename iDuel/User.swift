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
    
    let username: String
    var flick: CMGyroData?
    var currentPosition: CMGyroData?
    var calibrationLowered: CMGyroData?
    var calibrationRaised: CMGyroData?
    var duelIDs: [String]? = []
    let timestamp: NSDate
    var id: String?
    var endpoint: String {
        return "users"
    }
    
    init(username: String, flick: CMGyroData? = nil, currentPosition: CMGyroData? = nil, calibrationLowered: CMGyroData? = nil, calibrationRaised: CMGyroData? = nil, duelIDs:[String]? = [], id: String? = nil, timestamp: NSDate = NSDate()) {
        self.username = username
        self.flick = flick
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
        self.duelIDs = duelIDs
        self.timestamp = timestamp
    }
    
    private let kUsername = "username"
    private let kCurrentPosition = "currentPosition"
    private let kCalibrationLowered = "calibrationLowered"
    private let kCalibrationRaised = "calibrationRaised"
    private let kDuelIDs = "duelIDs"
    private let kTimestamp = "timestamp"
    
    var jsonValue: [String : AnyObject] {
        var json: [String: AnyObject] = [kUsername: username, kTimestamp: timestamp]
        if let duelIDs = duelIDs {
            json.updateValue(duelIDs, forKey: kDuelIDs)
        }
        return json
    }
    
    required init?(json: [String: AnyObject], id: String) {
        guard let username = json[kUsername] as? String,
            timestamp = json[kTimestamp] as? NSTimeInterval else { return nil }
        self.id = id
        self.username = username
        self.currentPosition = json[kCurrentPosition] as? CMGyroData
        self.calibrationLowered = json[kCalibrationLowered] as? CMGyroData
        self.calibrationRaised = json[kCalibrationRaised] as? CMGyroData
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        if let duelIDs = json[kDuelIDs] as? [String] {
            self.duelIDs = duelIDs
        }
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}