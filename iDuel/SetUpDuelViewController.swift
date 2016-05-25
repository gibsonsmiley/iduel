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
    
    var opponent: User?
    var duel: Duel?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        displayWithInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func displayWithInfo() {
        if self.opponent == nil {
            self.beginDuelButton.enabled = false
        } else {
            self.beginDuelButton.enabled = true
        }
    }
    
    func watchForPlayers() {
        guard let duel = self.duel else { return }
        FirebaseController.base.childByAppendingPath("users").queryOrderedByChild("duelIDs").queryEqualToValue("\(duel.id)").observeEventType(.Value, withBlock: { (snapshot) in
            if let jsonDictionary = snapshot.value as? [String: [String: AnyObject]] {
                let users = jsonDictionary.flatMap({User(json: $0.1, id: $0.0)})
                guard let duelID = duel.id else { return }
                for user in users where ((user.duelIDs?.contains(duelID)) != nil) {
                    if self.duel?.player2 == nil {
                        //user = self.duel?.player2
                    }
                }
//                guard let duelID = duel.id else { return }
//                guard let duel = Duel(json: jsonDictionary, id: duelID) else { return }
                
            } else {
                // No data returned?
            }
        })
        // DuelController.observePlayersForDuel(self.duel)
    }
    
    func updateWithDuel(duel: Duel) {
        self.duel = duel
    }
    
    // MARK: - Actions
    
    @IBAction func beginDuelButton(sender: AnyObject) {
        // If both players are present
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
