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
    private let kCurrentPosition = "currentPosition"
    private let kCalibrationLowered = "calibrationLowered"
    private let kCalibrationRaised = "calibrationRaised"
    private let kDuelIDs = "duelIDs"
    private let kTimestamp = "timestamp"
    
    
    var nickname: String
    var currentPosition: Calibration?
    var calibrationLowered: Calibration?
    var calibrationRaised: Calibration?
    var duelIDs: [String]?
    var timestamp: NSDate 
    var id: String?
    var endpoint: String {
        return "users"
    }
    
    init(nickname: String, currentPosition: Calibration? = nil, calibrationLowered: Calibration? = nil, calibrationRaised: Calibration? = nil,  duelIDs: [String]?, timestamp: NSDate = NSDate()) {
        self.nickname = nickname
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
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