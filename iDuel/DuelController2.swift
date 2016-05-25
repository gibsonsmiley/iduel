//
//  DuelController2.swift
//  Duellum
//
//  Created by Gibson Smiley on 5/25/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class DuelController2 {
    
    static func createDuel() {
        
    }
    
    static func joinDuel(duel: Duel, opponentID: String = UserController.sharedController.currentUser.id!, completion: (success: Bool) -> Void) {
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/opponentID").setValue(opponentID)
    }
    
    static func observePlayers(duel: Duel, completion: (challenger: User?, opponent: User?) -> Void) {
        var challenger: User?
        var opponent: User?
        guard let duelID = duel.id else { completion(challenger: nil, opponent: nil); return }
        FirebaseController.dataAtEndpoint("duels/\(duelID)/challengerID") { (data) in
            guard let challengerID = data as? String else { completion(challenger: nil, opponent: nil); return }
            UserController.fetchUserForIdentifier(challengerID, completion: { (user) in
                challenger = user
            })
            
        }
        FirebaseController.dataAtEndpoint("duels/\(duelID)/opponentID") { (data) in
            guard let opponentID = data as? String else { completion(challenger: nil, opponent: nil); return }
            UserController.fetchUserForIdentifier(opponentID, completion: { (user) in
                opponent = user
            })
        }
        print("challenger: \(challenger), opponent: \(opponent)")
        completion(challenger: challenger, opponent: opponent)
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
            completion(duels: duels)
        }
    }
    
    static func sendStatusToDuel(user: User, duel: Duel, completion: (success: Bool) -> Void) {
        guard let userID = user.id else { completion(success: false); return }
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/statuses").childByAppendingPath("\(userID)")
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
        let randomNumber = arc4random_uniform(2) + 2 // Gives random number between 2 and 4
        let countdown = NSNumber(unsignedInt: randomNumber)
        guard let duelID = duel.id else { completion(success: false); return}
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/countdown").setValue(countdown)
        completion(success: true)
    }
    
    static func observeCountdown(duel: Duel, completion: (countdown: Int64?) -> Void) {
        guard let duelID = duel.id else { completion(countdown: nil); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/countdown").observeEventType(.Value, withBlock: { (snapshot) in
            guard let countdown = snapshot.value as? Int64 else { completion(countdown: nil); return } // Cast may fail - may need to cast it as an NSNumber and then convert it to Int64
            completion(countdown: countdown)
        })
    }
    
    static func sendShotToDuel(duel: Duel, user: User, completion: (success: Bool) -> Void) {
        guard let userID = user.id else { completion(success: false); return }
        guard let duelID = duel.id else { completion(success: false); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/shotsFired").childByAppendingPath("\(userID)")
        completion(success: true)
    }
    
    static func observeShotsFired(duel: Duel, completion: (winner: User?, loser: User?) -> Void) {
        guard let duelID = duel.id else { completion(winner: nil, loser: nil); return }
        FirebaseController.base.childByAppendingPath("duels/\(duelID)/shotsFired").observeEventType(.Value, withBlock: { (snapshot) in
            guard let shots = snapshot.value as? [String] else { completion(winner: nil, loser: nil); return }
            if shots.count == 2 {
                var winner: User?
                var loser: User?
                guard let winnerID = shots.first else { completion(winner: nil, loser: nil); return }
                UserController.fetchUserForIdentifier(winnerID, completion: { (user) in
                    winner = user
                })
                guard let loserID = shots.last else { completion(winner: nil, loser: nil); return }
                UserController.fetchUserForIdentifier(loserID, completion: { (user) in
                    loser = user
                })
                print("winner: \(winner), loser: \(loser)")
                completion(winner: winner, loser: loser)
            }
        })
    }
}