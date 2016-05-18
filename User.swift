//
//  User.swift
//  Duellum
//
//  Created by mac-admin on 5/18/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreData
import CoreMotion

@objc(User)
class User: NSManagedObject, FirebaseType {
    
    
    private let kNickname = "nickname"
    private let kCurrentPosition = "currentPosition"
    private let kCalibrationLowered = "calibrationLowered"
    private let kCalibrationRaised = "calibrationRaised"
    private let kDuelIDs = "duelIDs"
    private let kTimestamp = "timestamp"
    
    
    
    var currentPosition: Calibration?
    var calibrationLowered: Calibration?
    var calibrationRaised: Calibration?
    var duelIDs: [String]? = []
    var timestamp: NSDate = NSDate()
    var id: String?
    var endpoint: String {
        return "users"
    }
    
    var jsonValue: [String : AnyObject] {
        if let nickname = nickname {
        var json: [String: AnyObject] = [kNickname: nickname, kTimestamp: timestamp.timeIntervalSince1970]
        if let duelIDs = duelIDs {
            json.updateValue(duelIDs, forKey: kDuelIDs)
        }
        return json
        }
    }
    
    
    convenience init(nickname: String, calibration: Calibration, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.nickname = nickname
        self.calibration = calibration
        
        
    }
    
    convenience required init?(json: [String: AnyObject], id: String) {
        guard let nickname = json[kNickname] as? String,
            timestamp = json[kTimestamp] as? NSTimeInterval else { return nil }
        self.id = id
        self.nickname = nickname
        self.currentPosition = json[kCurrentPosition] as? Calibration
        self.calibrationLowered = json[kCalibrationLowered] as? Calibration
        self.calibrationRaised = json[kCalibrationRaised] as? Calibration
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        if let duelIDs = json[kDuelIDs] as? [String] {
            self.duelIDs = duelIDs
        }
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}