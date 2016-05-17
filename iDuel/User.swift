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
    var currentUser: String?
    var flick: CMGyroData?
    var currentPosition: CMGyroData?
    var calibrationLowered: CMGyroData?
    var calibrationRaised: CMGyroData?
    let duelId: [String]
    var id: String?
    var endpoint: String {
        return "users"
    }
    
    
    init(username: String, currentUser: String, flick: CMGyroData?, currentPosition: CMGyroData?, calibrationLowered: CMGyroData?, calibrationRaised: CMGyroData?, duelId:[String]) {
        self.username = username
        self.currentUser = currentUser
        self.flick = flick
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
        self.duelId = duelId
    }
    
    private let kUsername = "username"
    private let kCurrentPosition = "currentPosition"
    private let kCalibrationLowered = "calibrationLowered"
    private let kCalibrationRaised = "calibrationRaised"
    private let kDuelId = "duelId"
    
    
    var jsonValue: [String : AnyObject]{
        if let currentPosition = currentPosition, calibrationLowered = calibrationLowered, calibrationRaised = calibrationRaised {
        return [kUsername: username, kCurrentPosition: currentPosition, kCalibrationLowered: calibrationLowered, kCalibrationRaised: calibrationRaised, kDuelId: duelId]
        }
        return self.jsonValue
    }

    
    required init?(json: [String: AnyObject], id: String) {
        guard let username = json[kUsername] as? String,
            currentPosition = json[kCurrentPosition] as? CMGyroData,
            calibrationLowered = json[kCalibrationLowered] as? CMGyroData,
            calibrationRaised = json[kCalibrationRaised] as? CMGyroData else {return nil}
        self.username = username
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}