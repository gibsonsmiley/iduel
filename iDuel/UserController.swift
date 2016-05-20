//
//  UserController.swift
//  iDuel
//
//  Created by mac-admin on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreData


class UserController {
    
    static let kUser = "user"
    static var currentUser: User! {
        get {
            guard let uid = FirebaseController.base.authData?.uid, let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kUser) as? [String: AnyObject] else { return nil }
            return User(json: userDictionary, id: uid)
        }
        set {
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }

    
    static func createUser(nickname: String, completion: (success: Bool, user: User?) -> Void) {
        FirebaseController.base.authAnonymouslyWithCompletionBlock { (error, authData) in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(success: false, user: nil)
            } else {
                if let uid = authData.uid {
                    var user = User(nickname: nickname, duelIDs: [])
                    user.id = uid
                    user.save()
                    completion(success: true, user: user)
                    self.currentUser = user
                }
            }
        }
    }
    
    static func deleteUser(user: User, completion: (success: Bool) -> Void) {
        user.delete()
        guard let userID = user.id else { completion(success: false); return }
        fetchUserForIdentifier(userID) { (user) in
            completion(success: true)
        }
    }
    
    static func fetchUserForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) in
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, id: identifier)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    static func fetchAllUsers(completion: (users: [User]?) -> Void) {
        FirebaseController.dataAtEndpoint("users") { (data) in
            if let json = data as? [String: AnyObject] {
                let users = json.flatMap({User(json: $0.1 as! [String: AnyObject], id: $0.0)})
                completion(users: users)
            } else {
                completion(users: nil)
            }
        }
    }
    
    static func observeDuelsForUser(user: User, completion: (duels: [Duel]?) -> Void) {
        guard let userID = user.id else { completion(duels: nil); return }
        FirebaseController.base.childByAppendingPath("users/\(userID)/duelIDs").observeEventType(.Value, withBlock: { (snapshot) in
            guard let duelIDsArray = snapshot.value as? [String] else { return }
            var duels: [Duel] = []
            for duelID in duelIDsArray {
                DuelController.fetchDuelForID(duelID, completion: { (duel) in
                    guard let duel = duel else { return }
                    duels.append(duel)
                })
            }
            completion(duels: duels)
        })
    }
    
    static func checkNicknameAvailability() {
        // May fill this in later
    }
}