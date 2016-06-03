//
//  WelcomeViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Has tutorial been displayed? \(NSUserDefaults.standardUserDefaults().boolForKey("tutorial"))")
        displayTutorial() // This is here because won't work in any other stage of the view creation/display
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
        if UserController.sharedController.currentUser == nil {
        } else {
            titleLabel.text = "Welcome back, \(UserController.sharedController.currentUser.nickname)"
            nicknameTextField.placeholder = "Change your nickname?"
        }
    }
    
    func errorManager(errorText: String) {
        self.errorLabel.hidden = false
        self.errorLabel.text = errorText
    }
    
    func displayTutorial() {
        if NSUserDefaults.standardUserDefaults().boolForKey("tutorial") == false {
            performSegueWithIdentifier("toTutorial", sender: self)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "tutorial")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func joinDuelButtonTapped(sender: AnyObject) {
        errorLabel.hidden = true
        if UserController.sharedController.currentUser == nil {
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
                if nicknameTextField.text != UserController.sharedController.currentUser.nickname {
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
        if UserController.sharedController.currentUser == nil {
            if nicknameTextField.text != "" {
                guard let nickname = nicknameTextField.text else { return }
                UserController.checkNicknameAvailability(nickname, completion: { (success, error) in
                    if success == true {
                        guard let currentUserID = UserController.sharedController.currentUser.id else { return }
                        DuelController2.createDuel(currentUserID, opponentID: nil, completion: { (success, duel) in
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
                guard let currentUserID = UserController.sharedController.currentUser.id else { return }
                DuelController2.createDuel(currentUserID, opponentID: nil, completion: { (success, duel) in
                    if success == true {
                        self.duel = duel
                        self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                    } else {
                        // Failed to create duel
                        self.errorManager("Couldn't create a new duel. Try again.")
                    }
                })
            } else {
                if nicknameTextField.text != UserController.sharedController.currentUser.nickname {
                    // User wants to change nickname
                    guard let nickname = nicknameTextField.text else { return }
                    UserController.checkNicknameAvailability(nickname, completion: { (success, error) in
                        if success == true {
                            guard let currentUserID = UserController.sharedController.currentUser.id else { return }
                            DuelController2.createDuel(currentUserID, opponentID: nil, completion: { (success, duel) in
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
                    guard let currentUserID = UserController.sharedController.currentUser.id else { return }
                    DuelController2.createDuel(currentUserID, opponentID: nil, completion: { (success, duel) in
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
            guard let destinationViewController = segue.destinationViewController as? SetUpDuelViewController else { return }
            guard let duel = self.duel else { return }
            destinationViewController.updateWithDuel(duel)
        }
    }
}