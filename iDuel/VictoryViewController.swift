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
    
    var duel: Duel?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func updateWithDuel(duel: Duel) {
        self.duel = duel
        
    }
    
    // MARK: - Actions
    
    @IBAction func playAgainButtonTapped(sender: AnyObject) {
        // Move back to duel view and create a new duel
//        DuelController.createDuel(<#T##player1: User##User#>, player2: <#T##User#>) { (success, duel) in
//            guard let duel = duel else { return }
//            let destinationViewController = self.presentingViewController as? DuelViewController
//            destinationViewController?.updateWithDuel(duel)
//        }
    }
    
    @IBAction func exitGameButtonTapped(sender: AnyObject) {
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
