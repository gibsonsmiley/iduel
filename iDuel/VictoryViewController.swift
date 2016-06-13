//
//  VictoryViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class VictoryViewController: UIViewController {
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var exitGameButton: UIButton!
    @IBOutlet weak var victoryImageView: UIImageView!
    
    var duel: Duel?
    var winner: User?
    var loser: User?
    
    // MARK: - View
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        watchForRematch()
        guard let currentUser = UserController.sharedController.currentUser,
            winner = self.winner,
            loser = self.loser else { return }
        if currentUser.nickname == winner.nickname {
            self.victoryImageView.image = UIImage(named: "VICTORYViewScreen")
            self.playAgainButton.enabled = false
        } else if currentUser.nickname == loser.nickname {
            self.victoryImageView.image = UIImage(named: "DEADViewScreen")
        } else {
            self.victoryImageView.image = UIImage(named: "tutorial")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        guard let duel = self.duel else { return }
        DuelController.deleteDuel(duel) { (success) in
            if success == true {
                print("Duel successfully deleted")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(rematch), name: "rematchFound", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func updateWithDuel(duel: Duel, winner: User, loser: User) {
        self.winner = winner
        self.loser = loser
        self.duel = duel
    }
    
    func rematch() {
        self.playAgainButton.enabled = true
    }
    
    func watchForRematch() {
        guard let currentUser = UserController.sharedController.currentUser,
            winner = winner,
            loser = loser,
            winnerID = winner.id,
            loserID = loser.id else { return }
        var opponentID: String?
        if currentUser == winner {
            opponentID = loserID
        } else {
            opponentID = winnerID
        }
        if FirebaseController.base.childByAppendingPath("duels").queryOrderedByChild("challengerID").queryEqualToValue("\(opponentID)") != nil {
            FirebaseController.base.childByAppendingPath("duels").queryOrderedByChild("challengerID").queryEqualToValue("\(opponentID)").observeEventType(.Value, withBlock: { (snapshot) in
                guard let jsonDictionary = snapshot.value as? [String: [String: AnyObject]] else { print("Cast probably failed"); return }
                guard let duel = jsonDictionary.flatMap({Duel(json: $0.1, id: $0.0)}).first else { print("Couldn't create duel from info received"); return }
                
                self.duel = duel
                NSNotificationCenter.defaultCenter().postNotificationName("rematchFound", object: nil)
            })
        } else {
            print("Couldn't find data equal to query")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func playAgainButtonTapped(sender: AnyObject) {
        guard let currentUser = UserController.sharedController.currentUser else { return }
        if currentUser.nickname == loser?.nickname {
            guard let currentUserID = UserController.sharedController.currentUser.id else { return }
            DuelController.createDuel(currentUserID, opponentID: nil) { (success, duel) in
                if success == true {
                    self.duel = duel
                    self.performSegueWithIdentifier("toRematch", sender: self)
                }
            }
        } else if currentUser.nickname == winner?.nickname {
            self.duel?.opponentID = UserController.sharedController.currentUser.id
            self.duel?.save()
            self.performSegueWithIdentifier("toRematch", sender: self)
        } else {
            self.playAgainButton.enabled = false
        }
    }
    
    @IBAction func exitGameButtonTapped(sender: AnyObject) {
        // Delete current duel
        // Move back to set up duel view
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toRematch" {
            guard let destinationViewController = segue.destinationViewController as? SetUpDuelViewController else { return }
            guard let duel = duel else { return }
            destinationViewController.updateWithDuel(duel)
        }
    }
}
