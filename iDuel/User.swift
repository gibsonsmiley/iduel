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
    
    private let kCurrentUser = "currentUser"
    private let kCurrentPosition = "currentPosition"
    private let kCalibrationLowered = "calibrationLowered"
    private let kCalibrationRaised = "calibrationRaised"
    
    
    let username: String
    var currentUser: String?
    var flick: CMGyroData?
    var currentPosition: CMGyroData?
    var calibrationLowered: CMGyroData?
    var calibrationRaised: CMGyroData?
    
    init(username: String, currentUser: String, flick: CMGyroData?, currentPosition: CMGyroData?, calibrationLowered: CMGyroData?, calibrationRaised: CMGyroData?) {
        self.username = username
        self.currentUser = currentUser
        self.flick = flick
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
        
    }
    
    
    required init?(json: [String: AnyObject]) {
        guard let currentUser = json[kCurrentUser] as? String,
            currentPosition = json[kCurrentPosition] as? CMGyroData,
            calibrationLowered = json[kCalibrationLowered] as? CMGyroData,
            calibrationRaised = json[kCalibrationRaised] as? CMGyroData else {return nil}
        self.currentUser = currentUser
        self.currentPosition = currentPosition
        self.calibrationLowered = calibrationLowered
        self.calibrationRaised = calibrationRaised
    
        
    
    }
}