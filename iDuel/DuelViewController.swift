//
//  DuelViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox

class DuelViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var gunImageView: UIButton!
    
    var duel: Duel?
    var winner: User?
    var loser: User?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handPosition()
        duelStart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: Methods
    
    func handPosition() {
        if NSUserDefaults.standardUserDefaults().boolForKey("leftHand") == true {
            gunImageView.setImage(UIImage(named: "LH Duel View"), forState: .Normal)
        } else {
            gunImageView.setImage(UIImage(named: "RH Duel View"), forState: .Normal)
        }
    }
    
    func updateWithDuel(duel: Duel) {
        self.duel = duel
    }
    
    func duelStart() {
        guard let currentUser = UserController.sharedController.currentUser else { return }
        guard let duel = self.duel else { return }
        MotionController.sharedController.beginMotionTracking { (currentPosition, raised, lowered) in
            if lowered == true {
                MotionController.sharedController.checkFlick({ (success) in // Does this function continue looking?
                    if success == true {
                        // Play "gun cocked" noise
                        DuelController2.sendStatusToDuel(currentUser, duel: duel, completion: { (success) in
                            if success == true {
                                DuelController2.sendCountdownToDuel(duel, completion: { (success) in
                                    if success == true {
                                        self.duelMid()
                                    } else {
                                        print("Couldn't send countdown to firebase")
                                    }
                                })
                            } else {
                                print("Couldn't send status to duel")
                            }
                        })
                    } else {
                        print("'Flick' not detected")
                    }
                })
            } else {
                print("Not in lowered position")
            }
        }
    }
    
    func duelMid() {
        guard let duel = duel else { return }
        DuelController2.observeCountdown(duel, completion: { (countdown) in
            if let countdown = countdown {
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), countdown)
                dispatch_after(time, dispatch_get_main_queue(), {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    MotionController.sharedController.beginMotionTracking { (currentPosition, raised, lowered) in
                        if raised == true {
                            self.fireButton.enabled = true
                        } else {
                            print("Not in raised position")
                        }
                    }
                })
            } else {
                print("Couldn't get countdown")
            }
        })
        
    }
    
    func duelEnd() {
        guard let duel = self.duel else { return }
        guard let currentUser = UserController.sharedController.currentUser else { return }
        DuelController2.observeShotsFired(duel) { (winner, loser) in
            if currentUser == winner {
                self.winner = currentUser
            } else {
                self.loser = currentUser
            }
            self.performSegueWithIdentifier("toVictory", sender: self)
            DuelController2.deleteDuel(duel, completion: { (success) in
                if success == true {
                    
                } else {
                    print("Couldn't delete duel")
                }
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        guard let duel = self.duel else { return }
        DuelController2.deleteDuel(duel) { (success) in
            if success == true {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("Couldn't delete duel")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func fireButtonTapped(sender: AnyObject) {
        // FIRE!
        guard let duel = self.duel else { return }
        DuelController2.sendShotToDuel(duel, user: UserController.sharedController.currentUser) { (success) in
            if success == true {
                self.duelEnd()
            } else {
                print("Couldn't send shot to firebase")
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toVictory" {
            guard let destinationViewController = segue.destinationViewController as?  VictoryViewController else { return }
            guard let duel = duel else { return }
            if winner != nil {
                destinationViewController.updateWithDuel(duel, victory: "winner")
            } else if loser != nil {
                destinationViewController.updateWithDuel(duel, victory: "loser")
            }
            _ = destinationViewController.view
        }
    }
}
