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
    @IBOutlet weak var toSetUpButton: UIButton!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var duelRequestTableView: UITableView!
    @IBOutlet weak var duelRequestsTitleLabel: UILabel!
    
    var duelRequests: [Duel] = []
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameTextField.delegate = self
        duelRequestTableView.delegate = self
        duelRequestTableView.dataSource = self
        
        fetchDuelRequests()
        titleState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        toSetUpButtonTapped(self)
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
            welcomeTitleLabel.text = "Welcome back \(UserController.currentUser?.nickname)!"
        }
        
        if self.duelRequests.count == 0 {
            duelRequestsTitleLabel.text = ""
        } else {
            duelRequestsTitleLabel.text = "Duel Requests (\(duelRequests.count)):"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func toSetUpButtonTapped(sender: AnyObject) { // Need some dispatch action all up in here, currently too slow
        errorLabel.hidden = true
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
                                                print("Current User: \(UserController.currentUser?.nickname)")
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
                        UserController.createUser(nickname, completion: { (success, user) in
                            if success {
                                UserController.currentUser = user
                                self.performSegueWithIdentifier("toSetUpDuel", sender: self)
                                print("Current User: \(UserController.currentUser?.nickname)")
                            } else {
                                self.errorLabel.hidden = false
                                self.errorLabel.text = "It didn't work. Try again."
                            }
                        })
                    }
                })
            } else {
                // Text field is empty
                self.errorLabel.hidden = false
                self.errorLabel.text = "You need to pick a nickname before continuing."
            }
        } else {
            performSegueWithIdentifier("toSetUpDuel", sender: self)
        }
    }
    
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
