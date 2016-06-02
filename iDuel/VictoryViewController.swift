//
//  VictoryViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class VictoryViewController: UIViewController {
    
    @IBOutlet weak var victoryLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var exitGameButton: UIButton!
    @IBOutlet weak var victoryImageView: UIImageView!
    
    var duel: Duel?
    var winner: User?
    var loser: User?
    
    enum victory {
        case Winner
        case Loser
    }
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func updateWithDuel(duel: Duel, winner: User, loser: User) {
        self.duel = duel
        self.winner = winner
        self.loser = loser
    }
    
    // MARK: - Actions
    
    @IBAction func playAgainButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func exitGameButtonTapped(sender: AnyObject) {
        // Delete current duel
        // Move back to set up duel view
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
