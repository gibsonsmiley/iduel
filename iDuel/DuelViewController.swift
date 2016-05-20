//
//  DuelViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit
import CoreMotion

class DuelViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fireButton: UIButton!
    
    var duel: Duel?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        duelStart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Methods
    
    func updateWithDuel(duel: Duel) {
        self.duel = duel
    }
    
    func duelStart() {
        MotionController.loadCalibration { (calibration) in
            if let calibration = calibration {
                MotionController.trackMotionForDuel({ (currentPosition) in
                    if let currentPosition = currentPosition {
                        MotionController.checkCalibration(calibration, currentMeasurements: currentPosition, completion: { (success) in
                            if success {
                                // If current position is algined with the lowered position calibrated average {
                                    // Watch for "cock" action THIS NEEDS A FUCKING METHOD {
                                        // Once "cock" action is detected play sound and call DuelController.playerReady function {
                                        // Need to figure out where to call the DuelController.checkReadyStatus function, maybe here?
                                            // Once checkReadyStatus returns two true bools call DuelController.startDuel
                                            // Call DuelController.victory
                                                // If winner { perform segue and updateWith(winner)
                                                // If loser { perform segue and updateWith(loser)
                            } else {
                                // Current position is not aligned with calibrated average
                            }
                        })
                    } else {
                        // No current position detected
                        
                    }
                })
            } else {
                // No calibration detected
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        // Stop duel and move back to set up view
        // Possibly alert opponent that duel was cancelled
    }
    
    @IBAction func fireButtonTapped(sender: AnyObject) {
        // FIRE!
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
