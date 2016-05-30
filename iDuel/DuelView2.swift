//
//  DuelView2.swift
//  Duellum
//
//  Created by Gibson Smiley on 5/30/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation
import MediaPlayer

class DuelView2: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var gunImageView: UIImageView!
    
    var duel: Duel?
    var winner: User?
    var loser: User?
    
    override func viewDidLoad() {
        if NSUserDefaults.standardUserDefaults().boolForKey("leftHand") == true {
            self.gunImageView.setImage(UIImage(named: "LH Duel View"), forState: .Normal)
        } else {
            self.gunImageView.setImage(UIImage(named: "RH Duel View"), forState: .Normal)
        }
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

@IBAction func fireButtonTapped(sender: AnyObject) {
    // FIRE!
    guard let duel = self.duel else { return }
    DuelController2.sendShotToDuel(duel, user: UserController.sharedController.currentUser) { (success) in
        if success == true {
            self.duelEnd()
        } else {
            // Couldn't send shot to firebase
        }
    }
}
}
