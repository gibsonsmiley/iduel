//
//  FindOpponentTableViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class FindOpponentTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allDuels: [Duel] = []
    var filteredDuels: [Duel] = []
    var selectedDuel: Duel?
    var challengers: [User] = []
    var filteredChallengers: [User] = []
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.keyboardDismissMode = .Interactive
        
        fetchAllDuels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func fetchAllDuels() {
        manageAllDuels { (duels) in
            guard let duels = duels else { return }
            self.allDuels = duels
            self.tableView.reloadData()
        }
    }
    
    func manageAllDuels(completion: (duels:[Duel]?) -> Void) {
        DuelController.fetchAllDuels { (duels) in
            guard let duels = duels else { completion(duels: nil); return }
            for duel in duels {
                if duel.timestamp.timeIntervalSinceNow > 30 * 60 {
                    DuelController.deleteDuel(duel, completion: { (success) in
                        if success == true {
                            // Successful deletion
                        } else {
                            // Deletion failed
                        }
                    })
                } else {
                    // Duel isn't older than a half hour - keep it
                    
                    self.allDuels.append(duel)
                }
            }
            completion(duels: self.allDuels)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // Need to capture the user that is associated with the nickname being typed in
        var challenger: User?
        guard let challengerID = challenger?.id else { return }
        FirebaseController.base.childByAppendingPath("users").queryOrderedByChild("nickname").queryEqualToValue("\(searchText)").observeEventType(.Value, withBlock: { (snapshot) in
            if let jsonDictionary = snapshot.value as? [String: [String: AnyObject]] {
                guard let user = jsonDictionary.flatMap({User(json: $0.1, id: $0.0)}).first else { return }
                challenger = user
            }
        })
        for duel in allDuels {
            if duel.challengerID == challengerID {
                self.filteredDuels = [duel]
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredDuels.count > 0 {
            return filteredDuels.count
        } else {
            return allDuels.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "FindOpponentScreen"))
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        var duel = allDuels[indexPath.row]
        if filteredDuels.count > 0 {
            duel = filteredDuels[indexPath.row]
        }
        if let duelID = duel.id {
            DuelController.fetchDuelForID(duelID, completion: { (duel) in
                if let challengerID = duel?.challengerID {
                    UserController.fetchUserForIdentifier(challengerID, completion: { (user) in
                        if user != UserController.sharedController.currentUser {
                            cell.textLabel?.text = user?.nickname
                        }
                    })
                }
            })
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if filteredDuels.count > 0 {
            self.selectedDuel = filteredDuels[indexPath.row]
            self.selectedDuel?.opponentID = UserController.sharedController.currentUser.id
            self.selectedDuel?.save()
            self.performSegueWithIdentifier("toDuelSetup", sender: self)
        } else {
            self.selectedDuel = allDuels[indexPath.row]
            self.selectedDuel?.opponentID = UserController.sharedController.currentUser.id
            self.selectedDuel?.save()
            self.performSegueWithIdentifier("toDuelSetup", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDuelSetup" {
            guard let destinationViewController = segue.destinationViewController as? SetUpDuelViewController else { return }
            guard let duel = self.selectedDuel else { return }
            destinationViewController.updateWithDuel(duel)
        }
    }
}






//    func fetchAllUsers() {
//        manageAllUsers({ (users) in
//            guard let users = users else { return }
//            self.allUsers = users
//            self.tableView.reloadData()
//        })
//    }

//    func manageAllUsers(completion: (users:[User]?) -> Void) {
//        UserController.fetchAllUsers { (users) in
//            guard let users = users else { completion(users: nil); return }
//            for user in users {
//                guard let userID = user.id else { return }
//                guard let currentUser = UserController.currentUser else { return }
//                if userID == currentUser.id {
//                } else {
//                    if user.timestamp.timeIntervalSinceNow > 24 * 60 * 60 {
//                        UserController.deleteUser(user, completion: { (success) in
//                            if success {
//                                // Successful deletion
//                            } else {
//                                // Deletion failed
//                            }
//                        })
//                    } else {
//                        // User is younger than 24 hours, keep them and return them in the completion
//                        self.allUsers.append(user)
//                    }
//                }
//            }
//            completion(users: self.allUsers)
//        }
//    }
