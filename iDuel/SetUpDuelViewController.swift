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
    var calibrations: [Calibration?]?
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
    }
    
    // MARK: - Methods
    
    func displayWithInfo() {
        if opponent == nil && calibrations == nil {
            beginDuelButton.enabled = false
        } else {
            beginDuelButton.enabled = true
        }
        
        guard let opponent = opponent else { return }
        selectOpponentButton.setTitle("\(opponent.nickname) (Tap to choose again)", forState: .Normal)
        guard calibrations != nil else { return }
        calibratePhoneButton.setTitle("Calibrated!", forState: .Normal)
        
        print(calibrations)
        print(opponent)
    }
    
    func getCalibrations(raised: Calibration, lowered: Calibration) {
        self.calibrations?.append(raised)
        self.calibrations?.append(lowered)
    }
    
    // MARK: - Actions
    
    @IBAction func calibratePhoneButtonTapped(sender: AnyObject) {
        // To calibrate views
    }
    
    @IBAction func selectOpponentButtonTapped(sender: AnyObject) {
        // To select opponent table view
        self.opponent = nil
    }
    
    @IBAction func themesButtonTapped(sender: AnyObject) {
        // Here just in case
    }
    
    @IBAction func beginDuelButton(sender: AnyObject) {
        if self.opponent != nil && self.calibrations != nil {
            guard let opponent = opponent,
                currentUser = UserController.currentUser else { return }
            print(opponent)
            DuelController.createDuel(currentUser, player2: opponent, completion: { (success, duel) in
                print(success)
                if success {
                    // Move to duel view
                    self.performSegueWithIdentifier("toDuelCustom", sender: self)
                } else {
                    // Display error alert
                }
            })
        } else {
            // Display alert saying an opponent and calibrations are necessary to continue
            if opponent == nil {
                self.selectOpponentButton.setTitle("Select Opponent (Required)", forState: .Normal)
            }
            if calibrations == nil {
                self.calibratePhoneButton.setTitle("Calibrate iPhone (Required)", forState: .Normal)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDuelCustom" {
            guard let destinationViewController = segue.destinationViewController as? DuelViewController else { return }
            guard let duel = self.duel else { return }
            destinationViewController.updateWithDuel(duel)
            _ = destinationViewController.view
        }
    }
}
