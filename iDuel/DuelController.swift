//
//  DuelController.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreMotion
import AudioToolbox

class DuelController {
    
    static let sharedController = DuelController()
    
    var challenger: User?
    var opponent: User?
    
    // Method to add player to duel's ready array, this is the gun cock
    // This is appending data to the firebase ready array under the user's id
    static func playerReady(user: User, duel: Duel, completion:(success: Bool) -> Void) {
        guard let userID = user.id else { completion(success: false); return }
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/status").setValue("\(userID)")
        completion(success: true)
    }
    
    static func duelStart(duel: Duel?, completion:(duel: Duel?, success: Bool) -> Void) {
        // User points phone down by waist, checks to see if the device is in range
        MotionController.sharedController.checkRange(false) { (success) in
            if success {
                print("Device at waist")
                MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                NSThread.sleepForTimeInterval(0.5)
                
                //User flicks phone to show they are ready for the duel to begin
                MotionController.sharedController.checkFlick({ (success) in
                    if success {
                        print("Flick successful")
                        MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                        SystemSoundID.playGunCocking("GunCocking", withExtenstion: "mp3")
                        
                        // check to see if there is a duel
                        if let duel = duel {
                            DuelController.sendStatusToDuel(UserController.sharedController.currentUser, duel: duel, completion: { (success) in
                                if success {
                                    completion(duel: duel, success: true)
                                } else {
                                    print("player 1 and player 2 not ready")
                                }
                            })
                        } else {
                            print("duel not ready")
                            
                        }
                    } else {
                        print("No flick detected")
                    }
                })
            } else {
                print("Device is not in range")
            }
        }
    }
    
    static func createDuel(challengerID: String = UserController.sharedController.currentUser.id!, opponentID: String?, completion: (success: Bool, duel: Duel?) -> Void) {
        var duel = Duel(challengerID: challengerID, opponentID: opponentID, statuses: nil, shotsFired: nil)
        duel.challengerID = challengerID
        duel.save()
        guard let duelID = duel.id else { completion(success: false, duel: nil); return }
        UserController.sharedController.currentUser.duelIDs?.append(duelID)
        completion(success: true, duel: duel)
    }
    
    static func joinDuel(duel: Duel, opponentID: String = UserController.sharedController.currentUser.id!, completion: (success: Bool) -> Void) {
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/opponentID").setValue(opponentID)
    }
    
    static func observePlayers(duel: Duel, completion: (challenger: User?, opponent: User?) -> Void) {
        guard let duelID = duel.id else { completion(challenger: nil, opponent: nil); return }
        FirebaseController.observeDataAtEndpoint("duels/\(duelID)/opponentID") { (data) in
            guard let opponentID = data as? String else { completion(challenger: nil, opponent: nil); return }
            UserController.fetchUserForIdentifier(opponentID, completion: { (user) in
                sharedController.opponent = user
                NSNotificationCenter.defaultCenter().postNotificationName("opponentJoined", object: self)
            })
        }
    }
    
    static func deleteDuel(duel: Duel, completion: (success: Bool) -> Void) {
        duel.delete()
        guard let duelID = duel.id else { completion(success: false); return }
        fetchDuelForID(duelID) { (duel) in
            completion(success: true)
        }
    }
    
    static func fetchDuelForID(id: String, completion: (duel: Duel?) -> Void) {
        FirebaseController.dataAtEndpoint("duels/\(id)") { (data) in
            guard let json = data as? [String: AnyObject] else { completion(duel: nil); return }
            let duel = Duel(json: json, id: id)
            completion(duel: duel)
        }
    }
    
    static func fetchAllDuels(completion: (duels: [Duel]?) -> Void) {
        FirebaseController.dataAtEndpoint("duels") { (data) in
            guard let json = data as? [String: AnyObject] else { completion(duels: nil); return }
            let duels = json.flatMap({Duel(json: $0.1 as! [String: AnyObject], id: $0.0)})
            let orderedDuels = orderDuels(duels)
            completion(duels: orderedDuels)
        }
    }
    
    static func sendStatusToDuel(user: User, duel: Duel, completion: (success: Bool) -> Void) {
        guard let userID = user.id else { completion(success: false); return }
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/statuses").childByAppendingPath("\(userID)").setValue("userReady")
        completion(success: true)
    }
    
    static func observeReadyStatuses(duel: Duel, completion: (playersReady: Bool) -> Void) {
        guard let duelID = duel.id else { completion(playersReady: false); return }
        FirebaseController.observeDataAtEndpoint("duels/\(duelID)/statuses") { (data) in
            guard let statuses = data as? [String: String] else { completion(playersReady: false); return }
            print("Statuses count: \(statuses.count)")
            if statuses.count == 2 {
                completion(playersReady: true)
            } else {
                print("Status count not equal to 2")
                completion(playersReady: false)
            }
        }
    }
    
    static func sendShotToDuel(duel: Duel, user: User, completion: (success: Bool) -> Void) {
        guard let userID = user.id else { completion(success: false); return }
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/shotsFired").childByAutoId().setValue("\(userID)")
        completion(success: true)
    }
    
    static func observeShotsFired(duel: Duel, completion: (winner: User?, loser: User?) -> Void) {
        guard let duelID = duel.id else { completion(winner: nil, loser: nil); return }
        FirebaseController.observeDataAtEndpoint("duels/\(duelID)/shotsFired") { (data) in
            guard let shotsDictionary = data as? [String: String] else { return }
            var usersArray: [User] = []
            for userID in shotsDictionary.values {
                UserController.fetchUserForIdentifier(userID, completion: { (user) in
                    guard let user = user else { return }
                    usersArray.append(user)
                    print("First in array:\(usersArray[0].nickname)")
                    if usersArray.count == 2 {
                        print("Second in array \(usersArray[1].nickname)")
                    }
                    var winner: User? = nil
                    var loser: User? = nil
                    if usersArray.count == 2 {
                        winner = usersArray[0]
                        loser = usersArray[1]
                        print("First in array is winner | Winner: \(winner!.nickname) Loser: \(loser!.nickname) on Controller")
                        completion(winner: winner, loser: loser)
                    } else {
                        print("User array not at 2")
                    }
                })
            }
        }
    }
    
    static func orderDuels(duels: [Duel]) -> [Duel] {
        return duels.sort({$0.0.timestamp.timeIntervalSince1970.hashValue >   $0.1.timestamp.timeIntervalSince1970.hashValue})
    }
    
}