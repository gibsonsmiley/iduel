//
//  234.swift
//  Duellum
//
//  Created by Gibson Smiley on 6/7/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation

class test {
    @IBAction func toSetUpButtonTapped(sender: AnyObject) { // Need some dispatch action all up in here, currently too slow
        errorLabel.hidden = true
        //        if UserController.currentUser == nil {
        if nicknameTextField.text != UserController.currentUser?.nickname {
            if nicknameTextField.text != "" {
                guard let nickname = nicknameTextField.text else { return }
                // Check if nickname already exists
                FirebaseController.base.childByAppendingPath("users").queryOrderedByChild("nickname").queryEqualToValue("\(nickname)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let jsonDictionary = snapshot.value as? [String : [String : AnyObject]] {
                        // Nickname already exists, check timestamp
                        guard let user = jsonDictionary.flatMap({User(json: $0.1, id: $0.0)}).first else { return }
                        if user == UserController.currentUser {
                            self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                        } else {
                            let timestamp = user.timestamp
                            if timestamp.timeIntervalSinceNow < 24 * 60 * 60 {
                                // Nickname was created over 24 hours ago, delete it and create a new one with the username
                                UserController.deleteUser(user, completion: { (success) in
                                    if success {
                                        UserController.createUser(nickname, completion: { (success, user) in
                                            if success {
                                                UserController.currentUser = user
                                                self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                                                self.errorLabel.hidden = false
                                                self.errorLabel.text = "Loading..."
                                            } else {
                                                self.errorLabel.hidden = false
                                                self.errorLabel.text = "It didn't work. Try again."
                                            }
                                        })
                                    } else {
                                        // Deleting didn't work. Just make user try a different nickname.
                                        self.errorLabel.hidden = false
                                        self.errorLabel.text = "That nickname is taken, try another. (Nicknames last for 24 hours.)"
                                    }
                                })
                            } else {
                                // Nickname was created within 24 hours, make user try another nickname
                                self.errorLabel.hidden = false
                                self.errorLabel.text = "That nickname is taken, try another. (Nicknames last for 24 hours.)"
                            }
                        }
                    } else {
                        // Nickname doesn't already exist, create new user
                        self.errorLabel.hidden = false
                        self.errorLabel.text = "Loading..."
                        UserController.createUser(nickname, completion: { (success, user) in
                            if success {
                                UserController.currentUser = user
                                self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                            } else {
                                self.errorLabel.hidden = false
                                self.errorLabel.text = "It didn't work. Try again."
                            }
                        })
                    }
                })
            } else {
                // Text field is empty
                if UserController.currentUser == nil {
                    self.errorLabel.hidden = false
                    self.errorLabel.text = "You need to pick a nickname before continuing."
                } else {
                    performSegueWithIdentifier("toSetUpDuel", sender: self)
                }
}