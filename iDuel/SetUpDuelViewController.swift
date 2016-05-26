//
//  SetUpDuelViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit
import CoreMotion

class SetUpDuelViewController: UIViewController {
    
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var challengerLabel: UILabel!
    @IBOutlet weak var beginDuelButton: UIButton!
    
    var duel: Duel?
    var challenger: User?
    var opponent: User?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewWithInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        watchForPlayers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func watchForPlayers() {
        guard let duel = self.duel else { return }
        DuelController2.observePlayers(duel) { (challenger, opponent) in
            if let challenger = challenger {
                self.challenger = challenger
            }
            if let opponent = opponent {
                self.opponent = opponent
            }
        }
    }
    
    func updateViewWithInfo() {
        guard let challengerID = self.duel?.challengerID else { return }
        UserController.fetchUserForIdentifier(challengerID) { (user) in
            guard let user = user else { return }
            //            self.challenger = user
            self.challengerLabel.text = user.nickname
        }
        guard let opponentID = self.duel?.opponentID else { return }
        UserController.fetchUserForIdentifier(opponentID) { (user) in
            //            self.opponent = user
            self.opponentLabel.text = user?.nickname
        }
    }
    
    func updateWithDuel(duel: Duel) {
        self.duel = duel
        UserController.fetchUserForIdentifier(duel.challengerID) { (user) in
            self.challenger = user
        }
        guard let opponentID = duel.opponentID else { return }
        UserController.fetchUserForIdentifier(opponentID) { (user) in
            self.opponent = user
        }
    }
    
    // MARK: - Actions
    
    @IBAction func beginDuelButton(sender: AnyObject) {
        // If both players are present
//        guard let duel = duel,
//            challenger = challenger,
//            opponent = opponent else { return }
        performSegueWithIdentifier("toDuelCustom", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDuelCustom" {
            guard let destinationViewController = segue.destinationViewController as? DuelViewController else { return }
            guard let duel = self.duel else { return }
            destinationViewController.updateWithDuel(duel)
            _ = destinationViewController.view // Don't know why this is needed
        }
    }
}
