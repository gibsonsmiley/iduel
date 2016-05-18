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
    
    static var currentUser: User?
    let kUser = "user"
    
    static func createUser(username: String, completion: (success: Bool, user: User?) -> Void) {
        FirebaseController.base.createUser("", password: "") { (error, response) in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(success: false, user: nil)
            } else {
                if let uid = response["uid"] as? String {
                    var user = User(
                        FirebaseController.base.childByAppendingPath("users").childByAppendingPath(uid).setValue(user.jsonValue)
                        user.save()
                        completion(success: true, user: user)
                        self.currentUser = user
                }
            }
        }
    }
    
    static func fetchUserForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) in
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: identifier)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        FirebaseController.dataAtEndpoint("users") { (data) in
            if let json = data as? [String: AnyObject] {
                let users = json.flatMap({User(json: $0.1 as! [String: AnyObject], identifier: $0.0)})
                completion(users: users)
            } else {
                completion(users: [])
            }
        }
    }
}