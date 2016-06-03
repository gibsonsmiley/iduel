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
        guard let currentUser = UserController.sharedController.currentUser,
            winner = self.winner,
            loser = self.loser else { return }
        if currentUser.nickname == winner.nickname {
            self.victoryImageView.image = UIImage(named: "VICTORYViewScreen")
        } else if currentUser.nickname == loser.nickname {
            self.victoryImageView.image = UIImage(named: "DEADViewScreen")
        } else {
            self.victoryImageView.image = UIImage(named: "tutorial")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let duel = self.duel else { return }
        DuelController2.deleteDuel(duel) { (success) in
            if success == true {
                print("Duel successfully deleted")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func updateWithDuel(winner: User, loser: User) {
        self.winner = winner
        self.loser = loser
    }
    
    // MARK: - Actions
    
    @IBAction func playAgainButtonTapped(sender: AnyObject) {
        guard let winner = winner,
            loser = loser,
            winnerID = winner.id,
            loserID = loser.id else { return }
        DuelController2.createDuel(loserID, opponentID: winnerID) { (success, duel) in
            if success == true {
                self.duel = duel
            }
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
            guard let duel = self.duel else { return }
            destinationViewController.updateWithDuel(duel)
        }
    }
}
