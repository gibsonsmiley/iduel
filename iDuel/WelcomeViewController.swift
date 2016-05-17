//
//  WelcomeViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var toSetUpButton: UIButton!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    
    
    // MARK: - Actions
    
    @IBAction func toSetUpButtonTapped(sender: AnyObject) {
        if UserController.currentUser == nil {
            errorLabel.hidden = true
            if nicknameTextField.text != "" {
                guard let nickname = nicknameTextField.text else { return }
                UserController.fetchAllUsers({ (users) in
                    if users != nil {
                        var sameNicknameUser: User?
                        guard let users = users else { return }
                        for user in users where user.nickname == "\(nickname)" {
                            sameNicknameUser = user
                            if sameNicknameUser == nil {
                                UserController.createUser(nickname, completion: { (success, user) in
                                    if success {
                                        UserController.currentUser = user
                                        self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                                    } else {
                                        self.errorLabel.hidden = false
                                        self.errorLabel.text = "It didn't work. Try again."
                                    }
                                })
                            } else {
                                guard let user = sameNicknameUser else { return }
                                let timestamp = user.timestamp
                                if timestamp.timeIntervalSinceNow > 24 * 60 * 60 {
                                    UserController.deleteUser(user, completion: { (success) in
                                        if success {
                                            UserController.createUser(nickname, completion: { (success, user) in
                                                if success {
                                                    UserController.currentUser = user
                                                    self.performSegueWithIdentifier("toSetUpDuel", sender: self)
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
                                    self.errorLabel.hidden = false
                                    self.errorLabel.text = "That nickname is taken, try another. (Nicknames last for 24 hours.)"
                                }
                            }
                        }
                    } else {
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
                errorLabel.hidden = false
                errorLabel.text = "You need to pick a nickname before continuing."
            }
        } else {
            // User is already logged in
        }
    }
    
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("toSettings", sender: self)
        // Display settings
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
