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

    @IBOutlet weak var calibratePhoneButton: UIButton!
    @IBOutlet weak var selectOpponentButton: UIButton!
    @IBOutlet weak var themesButton: UIButton!
    @IBOutlet weak var beginDuelButton: UIButton!
    
    var opponent: User?
    var calibrations: [CMGyroData]?
    var duel: Duel?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayWithInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func displayWithInfo() {
        if opponent == nil || calibrations == nil {
            beginDuelButton.enabled = false
        } else {
            beginDuelButton.enabled = true
        }
        guard let opponent = opponent else { return }
            selectOpponentButton.setTitle("\(opponent.nickname) (Tap to choose again)", forState: .Normal)
        guard calibrations != nil else { return }
        calibratePhoneButton.setTitle("Calibrated!", forState: .Normal)
    }
    
    // MARK: - Actions
    
    @IBAction func calibratePhoneButtonTapped(sender: AnyObject) {
        // To calibrate views
    }
    
    @IBAction func selectOpponentButtonTapped(sender: AnyObject) {
        // To select opponent table view
    }
    
    @IBAction func themesButtonTapped(sender: AnyObject) {
        // Here just in case
    }
    
    @IBAction func beginDuelButton(sender: AnyObject) {
        if self.opponent != nil && self.calibrations != nil {
            guard let opponent = opponent,
            currentUser = UserController.currentUser else { return }
            DuelController.createDuel(currentUser, player2: opponent, completion: { (success, duel) in
                if success {
                    
                    // Move to duel view
                } else {
                    // Display error alert
                }
            })
        } else {
            // Display alert saying an opponent and calibrations are necessary to continue
        }
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
