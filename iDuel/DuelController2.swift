//
//  DuelController2.swift
//  Duellum
//
//  Created by Gibson Smiley on 5/25/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class DuelController2 {
    
    static let sharedController = DuelController2()
    
    var challenger: User?
    var opponent: User?
    
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
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/statuses").observeEventType(.Value, withBlock: { (snapshot) in
            guard let statuses = snapshot.value as? [String] else { completion(playersReady: false); return }
            if statuses.count == 2 {
                completion(playersReady: true)
            }
        })
    }
    
    static func sendCountdownToDuel(duel: Duel, completion: (success: Bool) -> Void) {
        let randomNumber = arc4random_uniform(3) + 3 // Gives random number between 2 and 4
        let countdown = NSNumber(unsignedInt: randomNumber)
        guard let duelID = duel.id else { completion(success: false); return}
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/countdown").setValue(countdown)
        completion(success: true)
    }
    
    static func observeCountdown(duel: Duel, completion: (countdown: Int64?) -> Void) {
        guard let duelID = duel.id else { completion(countdown: nil); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/countdown").observeEventType(.Value, withBlock: { (snapshot) in
            guard let countdown = snapshot.value as? NSNumber else { completion(countdown: nil); return } // Cast may fail - may need to cast it as an NSNumber and then convert it to Int64
            let countdownInt = countdown.integerValue
            let countdownInt64 = Int64(countdownInt)
            completion(countdown: countdownInt64)
        })
    }
    
    static func sendShotToDuel(duel: Duel, user: User, completion: (success: Bool) -> Void) {
        guard let userID = user.id else { completion(success: false); return }
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/shotsFired").childByAppendingPath("\(userID)").setValue("\(NSDate().timeIntervalSince1970)")
        sleep(3)
        completion(success: true)
    }
    
    static func observeShotsFired(duel: Duel, completion: (winner: User?, loser: User?) -> Void) {
        guard let duelID = duel.id else { completion(winner: nil, loser: nil); return }
        FirebaseController.observeDataAtEndpoint("duels/\(duelID)/shotsFired") { (data) in
            guard let shotsDictionary = data as? [String: String] else { return }
            var usersArray: [User] = []
            var timestamps: [NSDate] = []
            for userID in shotsDictionary.keys {
                UserController.fetchUserForIdentifier(userID, completion: { (user) in
                    guard let user = user else { return }
                    usersArray.append(user)
                    for interval in shotsDictionary.values {
                        if let timeInterval = NSTimeInterval(interval) {
                            let timestamp = NSDate(timeIntervalSince1970: timeInterval)
                            timestamps.append(timestamp)
                            var winner: User? = nil
                            var loser: User? = nil
                            if usersArray.count == 2 {
                                guard let first = timestamps.first,
                                    last = timestamps.last else { print("One or neither shot(s) detetected"); return }
                                if first.isGreaterThanDate(last) {
                                    winner = usersArray[1]
                                    loser = usersArray[0]
                                    print("0>1 Winner: \(winner!.nickname) Loser: \(loser!.nickname) on Controller")
                                    completion(winner: winner, loser: loser)
                                } else {
                                    winner = usersArray[0]
                                    loser = usersArray[1]
                                    print("0<1 Winner: \(winner!.nickname) Loser: \(loser!.nickname) on Controller")
                                    completion(winner: winner, loser: loser)
                                }
                            } else {
                                print("User array not at 2")
                            }
                        }
                    }
                })
            }
        }
    }
    
    static func orderDuels(duels: [Duel]) -> [Duel] {
        return duels.sort({$0.0.timestamp.timeIntervalSince1970.hashValue >   $0.1.timestamp.timeIntervalSince1970.hashValue})
    }
    
}