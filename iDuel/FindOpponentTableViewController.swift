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
    
    var allUsers: [User] = []
    var filteredUsers: [User] = []
    
    var allDuels: [Duel] = []
    var filteredDuels: [Duel] = []
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.keyboardDismissMode = .Interactive
        
        fetchAllDuels()
        //        fetchAllUsers()
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
                //                guard let duelID = duel.id else { return }
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
        filteredDuels = allDuels.filter({
            ($0.player1?.nickname.lowercaseString.containsString(searchText.lowercaseString))! // This force unwrap may be a problem
        })
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
        cell.textLabel?.text = duel.player1?.nickname
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        guard let destinationVCNavController = presentingViewController as? UINavigationController,
//            destinationViewController = destinationVCNavController.childViewControllers[1] as? SetUpDuelViewController else { return }
//        destinationViewController.duel = allDuels[indexPath.row]
        guard let currentUser = UserController.currentUser else { return }
        guard let selectedDuelID = allDuels[indexPath.row].id else { return }
        currentUser.duelIDs?.append(selectedDuelID)
        if filteredDuels.count > 0 {
            guard let filteredDuelID = filteredDuels[indexPath.row].id else { return }
            currentUser.duelIDs?.append(filteredDuelID)
//            destinationViewController.duel = filteredDuels[indexPath.row]
        }
        self.performSegueWithIdentifier("toDuelSetup", sender: self)
//        dismissViewControllerAnimated(true, completion: nil)
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
