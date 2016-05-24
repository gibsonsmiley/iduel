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
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.keyboardDismissMode = .Interactive
        fetchAllUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func fetchAllUsers() {
        manageAllUsers({ (users) in
            guard let users = users else { return }
            self.allUsers = users
            self.tableView.reloadData()
        })
    }
    
    func manageAllUsers(completion: (users:[User]?) -> Void) {
        UserController.fetchAllUsers { (users) in
            guard let users = users else { completion(users: nil); return }
            for user in users {
                guard let userID = user.id else { return }
                guard let currentUser = UserController.currentUser else { return }
                if userID == currentUser.id {
                } else {
                    if user.timestamp.timeIntervalSinceNow > 24 * 60 * 60 {
                        UserController.deleteUser(user, completion: { (success) in
                            if success {
                                // Successful deletion
                            } else {
                                // Deletion failed
                            }
                        })
                    } else {
                        // User is younger than 24 hours, keep them and return them in the completion
                        self.allUsers.append(user)
                    }
                }
            }
            completion(users: self.allUsers)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = allUsers.filter({
            $0.nickname.lowercaseString.containsString(searchText.lowercaseString)
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
        if filteredUsers.count > 0 {
            return filteredUsers.count
        } else {
            return allUsers.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        
        var user = allUsers[indexPath.row]
        if filteredUsers.count > 0 {
            user = filteredUsers[indexPath.row]
        }
        cell.textLabel?.text = user.nickname
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let destinationVCNavController = presentingViewController as? UINavigationController,
            destinationViewController = destinationVCNavController.childViewControllers[1] as? SetUpDuelViewController else { return }
        destinationViewController.opponent = allUsers[indexPath.row]
        if filteredUsers.count > 0 {
            destinationViewController.opponent = filteredUsers[indexPath.row]
        }
        
        dismissViewControllerAnimated(true, completion: nil)
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
