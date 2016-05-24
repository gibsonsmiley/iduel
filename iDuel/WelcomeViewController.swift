//
//  WelcomeViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var joinDuelButton: UIButton!
    @IBOutlet weak var createDuelButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var duelRequests: [Duel] = []
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDuelRequests()
        titleState()
        self.errorLabel.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nicknameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func userTappedView(sender: AnyObject) {
        nicknameTextField.resignFirstResponder()
    }
    
    func fetchDuelRequests() {
        guard let currentUser = UserController.currentUser else { return }
        UserController.observeDuelsForUser(currentUser) { (duels) in
            guard let duels = duels else { return }
            self.duelRequests = duels
        }
    }
    
    func titleState() {
        if UserController.currentUser == nil {
            welcomeTitleLabel.text = "Welcome to Duellum! \nChoose a nickname to get started."
        } else {
            guard let user = UserController.currentUser else { return }
            welcomeTitleLabel.text = "Welcome back \(user.nickname)!"
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
                        self.performSegueWithIdentifier(/*Choose duel*/, sender: self)
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
                self.performSegueWithIdentifier(/*Choose duel*/, sender: self)
            } else {
                if nicknameTextField.text != UserController.currentUser.nickname {
                    // User wants to change nickname
                    guard let nickname = nicknameTextField.text else { return }
                    UserController.checkNicknameAvailability(nickname, completion: { (success, error) in
                        if success == true {
                            self.performSegueWithIdentifier(/*Choose duel*/, sender: self)
                        } else {
                            // Function returned false
                            guard let error = error else { return }
                            self.errorManager(error)
                        }
                    })
                } else {
                    self.performSegueWithIdentifier(/*Choose duel*/, sender: self)
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
                        self.performSegueWithIdentifier("toSetUpDuel", sender: self)
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
                self.performSegueWithIdentifier("toSetUpDuel", sender: self)
            } else {
                if nicknameTextField.text != UserController.currentUser.nickname {
                    // User wants to change nickname
                    guard let nickname = nicknameTextField.text else { return }
                    UserController.checkNicknameAvailability(nickname, completion: { (success, error) in
                        if success == true {
                            self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                        } else {
                            // Function returned false
                            guard let error = error else { return }
                            self.errorManager(error)
                        }
                    })
                } else {
                    self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                }
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
    
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("toSettings", sender: self)
        // Display settings
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duelRequests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCell", forIndexPath: indexPath)
        let duel = duelRequests[indexPath.row]
        if duel.player1 != UserController.currentUser {
            cell.textLabel?.text = duel.player1.nickname
        } else {
            cell.textLabel?.text = duel.player2.nickname
        }
        return cell
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
