//
//  User.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreMotion

class User {
    
    private let kUsername = "username"
    private let kCurrentPosition = "currentPosition"
    private let kCalibrationLowered = "calibrationLowered"
    private let kCalibrationRaised = "calibrationRaised"
    
    let username: String
    var currentUser: String?
    var flick: CMRotationRate?
    var currentPosition: CMRotationRate?
    var calibrationLowered: CMRotationRate?
    var calibrationRaised: CMRotationRate?
    
    init(username: String, currentUser: String, flick: CMRotationRate?, currentPosition: CMRotationRate?, calibrationLowered: CMRotationRate?, calibrationRaised: CMRotationRate?) {
        self.username = username
        self.currentUser = currentUser
        self.flick = flick
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
    }
    
    required init?(json: [String: AnyObject], identifier: String) {
        guard let username = json[kUsername] as? String,
            currentPosition = json[kCurrentPosition] as? CMRotationRate,
            calibrationLowered = json[kCalibrationLowered] as? CMRotationRate,
            calibrationRaised = json[kCalibrationRaised] as? CMRotationRate else {return nil}
        self.username = username
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
    }
}