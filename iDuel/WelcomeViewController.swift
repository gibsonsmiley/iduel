//
//  WelcomeViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var joinDuelButton: UIButton!
    @IBOutlet weak var createDuelButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var duel: Duel?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleState()
        self.errorLabel.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nicknameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func userTappedView(sender: AnyObject) {
        nicknameTextField.resignFirstResponder()
    }
    
    func titleState() {
        if UserController.currentUser == nil {
        } else {
            nicknameTextField.placeholder = "Change your nickname"
        }
    }
    
    func errorManager(errorText: String) {
        self.errorLabel.hidden = false
        self.errorLabel.text = errorText
    }
    
    // MARK: - Actions
    
    @IBAction func joinDuelButtonTapped(sender: AnyObject) {
        errorLabel.hidden = true
        if UserController.currentUser == nil {
            if nicknameTextField.text != "" {
                guard let nickname = nicknameTextField.text else { return }
                UserController.checkNicknameAvailability(nickname, completion: { (success, error) in
                    if success == true {
                        self.performSegueWithIdentifier("toDuels", sender: self)
                    } else {
                        // Function returned false
                        guard let error = error else { return }
                        self.errorManager(error)
                    }
                })
            } else {
                // Nickname text field is empty
                errorManager("You need to enter a nickname.")
            }
        } else {
            // There is a current user
            if nicknameTextField.text == "" {
                // Field is empty - move to next view
                self.performSegueWithIdentifier("toDuels", sender: self)
            } else {
                if nicknameTextField.text != UserController.currentUser.nickname {
                    // User wants to change nickname
                    guard let nickname = nicknameTextField.text else { return }
                    UserController.checkNicknameAvailability(nickname, completion: { (success, error) in
                        if success == true {
                            self.performSegueWithIdentifier("toDuels", sender: self)
                        } else {
                            // Function returned false
                            guard let error = error else { return }
                            self.errorManager(error)
                        }
                    })
                } else {
                    self.performSegueWithIdentifier("toDuels", sender: self)
                }
            }
        }
    }
    
    @IBAction func createDuelButtonTapped(sender: AnyObject) {
        errorLabel.hidden = true
        if UserController.currentUser == nil {
            if nicknameTextField.text != "" {
                guard let nickname = nicknameTextField.text else { return }
                UserController.checkNicknameAvailability(nickname, completion: { (success, error) in
                    if success == true {
                        guard let currentUser = UserController.currentUser else { return }
                        DuelController.createDuel(currentUser, player2: nil, completion: { (success, duel) in
                            if success == true {
                                self.duel = duel
                                self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                            } else {
                                // Failed to create duel
                                self.errorManager("Couldn't create a new duel. Try again.")
                            }
                        })
                    } else {
                        // Function returned false
                        guard let error = error else { return }
                        self.errorManager(error)
                    }
                })
            } else {
                // Nickname text field is empty
                errorManager("You need to enter a nickname.")
            }
        } else {
            // There is a current user
            if nicknameTextField.text == "" {
                // Field is empty - move to next view
                guard let currentUser = UserController.currentUser else { return }
                DuelController.createDuel(currentUser, player2: nil, completion: { (success, duel) in
                    if success == true {
                        self.duel = duel
                        self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                    } else {
                        // Failed to create duel
                        self.errorManager("Couldn't create a new duel. Try again.")
                    }
                })
            } else {
                if nicknameTextField.text != UserController.currentUser.nickname {
                    // User wants to change nickname
                    guard let nickname = nicknameTextField.text else { return }
                    UserController.checkNicknameAvailability(nickname, completion: { (success, error) in
                        if success == true {
                            guard let currentUser = UserController.currentUser else { return }
                            DuelController.createDuel(currentUser, player2: nil, completion: { (success, duel) in
                                if success == true {
                                    self.duel = duel
                                    self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                                } else {
                                    // Failed to create duel
                                    self.errorManager("Couldn't create a new duel. Try again.")
                                }
                            })
                        } else {
                            // Function returned false
                            guard let error = error else { return }
                            self.errorManager(error)
                        }
                    })
                } else {
                    guard let currentUser = UserController.currentUser else { return }
                    DuelController.createDuel(currentUser, player2: nil, completion: { (success, duel) in
                        if success == true {
                            self.duel = duel
                            self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                        } else {
                            // Failed to create duel
                            self.errorManager("Couldn't create a new duel. Try again.")
                        }
                    })
                }
            }
        }
    }
    
    
    
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("toSettings", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSetUpDuel" {
            guard let destinationViewController = segue.sourceViewController as? SetUpDuelViewController else { return }
            guard let duel = self.duel else { return }
            destinationViewController.updateWithDuel(duel)
        }
    }
}




//    @IBAction func toSetUpButtonTapped(sender: AnyObject) { // Need some dispatch action all up in here, currently too slow
//        errorLabel.hidden = true
////        if UserController.currentUser == nil {
//            if nicknameTextField.text != UserController.currentUser?.nickname {
//                if nicknameTextField.text != "" {
//                    guard let nickname = nicknameTextField.text else { return }
//                    // Check if nickname already exists
//                    FirebaseController.base.childByAppendingPath("users").queryOrderedByChild("nickname").queryEqualToValue("\(nickname)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//                        if let jsonDictionary = snapshot.value as? [String : [String : AnyObject]] {
//                            // Nickname already exists, check timestamp
//                            guard let user = jsonDictionary.flatMap({User(json: $0.1, id: $0.0)}).first else { return }
//                            if user == UserController.currentUser {
//                                self.performSegueWithIdentifier("toSetUpDuel", sender: self)
//                            } else {
//                                let timestamp = user.timestamp
//                                if timestamp.timeIntervalSinceNow < 24 * 60 * 60 {
//                                    // Nickname was created over 24 hours ago, delete it and create a new one with the username
//                                    UserController.deleteUser(user, completion: { (success) in
//                                        if success {
//                                            UserController.createUser(nickname, completion: { (success, user) in
//                                                if success {
//                                                    UserController.currentUser = user
//                                                    self.performSegueWithIdentifier("toSetUpDuel", sender: self)
//                                                    self.errorLabel.hidden = false
//                                                    self.errorLabel.text = "Loading..."
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
//                                    // Nickname was created within 24 hours, make user try another nickname
//                                    self.errorLabel.hidden = false
//                                    self.errorLabel.text = "That nickname is taken, try another. (Nicknames last for 24 hours.)"
//                                }
//                            }
//                        } else {
//                            // Nickname doesn't already exist, create new user
//                            self.errorLabel.hidden = false
//                            self.errorLabel.text = "Loading..."
//                            UserController.createUser(nickname, completion: { (success, user) in
//                                if success {
//                                    UserController.currentUser = user
//                                    self.performSegueWithIdentifier("toSetUpDuel", sender: self)
//                                } else {
//                                    self.errorLabel.hidden = false
//                                    self.errorLabel.text = "It didn't work. Try again."
//                                }
//                            })
//                        }
//                    })
//                } else {
//                    // Text field is empty
//                    if UserController.currentUser == nil {
//                        self.errorLabel.hidden = false
//                        self.errorLabel.text = "You need to pick a nickname before continuing."
//                    } else {
//                        performSegueWithIdentifier("toSetUpDuel", sender: self)
//                    }
//                }
//            } else {
//                performSegueWithIdentifier("toSetUpDuel", sender: self)
//            }
////        } else {
////            // Nickname was created within 24 hours, make user try another nickname
////            self.errorLabel.hidden = false
////            self.errorLabel.text = "That nickname is taken, try another. (Nicknames last for 24 hours.)"
////        }
//    }
