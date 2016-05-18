//
//  File.swift
//  Duellum
//
//  Created by Gibson Smiley on 5/17/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class TestFile {
    
    // MARK: - This is the old way of picking a nickname if the new way doesn't work
    
    //                UserController.fetchAllUsers({ (users) in
    //                    if users != nil {
    //                        var sameNicknameUser: User?
    //                        guard let users = users else { return }
    //                        for user in users where user.nickname == "\(nickname)" {
    //                            sameNicknameUser = user
    //                            if sameNicknameUser == nil {
    //                                UserController.createUser(nickname, completion: { (success, user) in
    //                                    if success {
    //                                        UserController.currentUser = user
    //                                        self.performSegueWithIdentifier("toSetUpDuel", sender: self)
    //                                    } else {
    //                                        self.errorLabel.hidden = false
    //                                        self.errorLabel.text = "It didn't work. Try again."
    //                                    }
    //                                })
    //                            } else {
    //                                guard let user = sameNicknameUser else { return }
    //                                let timestamp = user.timestamp
    //                                if timestamp.timeIntervalSinceNow > 24 * 60 * 60 {
    //                                    UserController.deleteUser(user, completion: { (success) in
    //                                        if success {
    //                                            UserController.createUser(nickname, completion: { (success, user) in
    //                                                if success {
    //                                                    UserController.currentUser = user
    //                                                    self.performSegueWithIdentifier("toSetUpDuel", sender: self)
    //                                                } else {
    //                                                    self.errorLabel.hidden = false
    //                                                    self.errorLabel.text = "It didn't work. Try again."
    //                                                }
    //                                            })
    //                                        } else {
    //                                            // Deleting didn't work. Just make user try a different nickname.
    //                                            self.errorLabel.hidden = false
    //                                            self.errorLabel.text = "That nickname is taken, try another. (Nicknames last for 24 hours.)"
    //                                        }
    //                                    })
    //                                } else {
    //                                    self.errorLabel.hidden = false
    //                                    self.errorLabel.text = "That nickname is taken, try another. (Nicknames last for 24 hours.)"
    //                                }
    //                            }
    //                        }
    //                    } else {
    //                        UserController.createUser(nickname, completion: { (success, user) in
    //                            if success {
    //                                UserController.currentUser = user
    //                                self.performSegueWithIdentifier("toSetUpDuel", sender: self)
    //                            } else {
    //                                self.errorLabel.hidden = false
    //                                self.errorLabel.text = "It didn't work. Try again."
    //                        })
    
    
}