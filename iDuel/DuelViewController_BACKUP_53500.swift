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
<<<<<<< HEAD
=======
import AVFoundation
import MediaPlayer
>>>>>>> 7affbb1b9cc8df3e54ae501739d5107f7f195e94

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
        
<<<<<<< HEAD
        handPosition()
        duelStart()
=======
        DuelController.duelStart(duel) { (success) in
            if success {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.volumeChanged(_:)), name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
                let frame = CGRect(x: 0, y: -100, width: 10, height: 0)
                let volumeView = MPVolumeView(frame: frame)
                volumeView.sizeToFit()
                UIApplication.sharedApplication().windows.first?.addSubview(volumeView)
            }
        }
>>>>>>> 7affbb1b9cc8df3e54ae501739d5107f7f195e94
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
<<<<<<< HEAD
    func duelStart() {
        guard let currentUser = UserController.sharedController.currentUser else { return }
        guard let duel = self.duel else { return }
        MotionController.sharedController.beginMotionTracking { (currentPosition, raised, lowered) in
            if lowered == true {
                print("In lowered position")
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
=======
//    func duelStart() {
//        MotionController.sharedController.checkRange(false) { (success) in
//            if success {
//                MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
//                MotionController.sharedController.checkFlick({ (success) in
//                    if success {
//                        if let duel = self.duel {
//                            DuelController.playerReady(UserController.currentUser, duel: duel, completion: { (success) in
//                                if success {
//                                    DuelController.checkReadyStatus(duel, player1: duel.player1, player2: duel.player2, completion: { (player1Ready, player2Ready) in
//                                        if player1Ready && player2Ready {
//                                            DuelController.startDuel(duel)
//                                        }
//                                    })
//                                }
//                            })
//                        }
//                    }
//                })
//            }
//        }
//  }
        
        //        MotionController.sharedController.trackMotionForDuel { (currentPosition) in
        //            guard let currentPosition = currentPosition else { return }
        //           MotionController.sharedController.loadCalibration("lowered", completion: { (calibration) in
        //              guard let loweredPosition = calibration else { return }
        //            MotionController.sharedController.checkCalibration(loweredPosition, currentMeasurements: currentPosition, completion: { (success) in
        //            if success {
        //                  guard let duel = self.duel else { return }
        //              MotionController.sharedController.playerReady(UserController.currentUser, duel: duel, currentPosition: currentPosition, savedCalibration: loweredPosition, completion: { (success) in
        //                if success {
        // Play gun cock sound
        //                  DuelController.checkReadyStatus(duel, player1: duel.player1, player2: duel.player2, completion: { (player1Ready, player2Ready) in
        //                  if player1Ready == true && player2Ready == true {
        //                        DuelController.startDuel(duel)
        //                    DuelController.victory(duel, completion: { (winner, loser) in
        //                      if winner == UserController.currentUser {
        //                            self.winner = UserController.currentUser
        //                        self.performSegueWithIdentifier("toVictory", sender: self)
        //                  } else if loser == UserController.currentUser {
        //                    self.loser = UserController.currentUser
        //                  self.performSegueWithIdentifier("toVictory", sender: self)
        //            }
        //      })
        //                  } else {
        //Both players are not ready
        //                    }
        //                  })
        //                } else {
        //                      // No "gun cock" detected
        //                    }
        //                 })
        //               } else {
        // Current position is not aligned with calibrated average
        //                 }
        //              })
        //        })
        //       }
    
>>>>>>> 7affbb1b9cc8df3e54ae501739d5107f7f195e94
    
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
    
    func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    
                    self.view.backgroundColor = .redColor()
                    //let systemSoundID: SystemSoundID = SystemSoundID.playGunShot1("1gunshot")
                    let systemSoundID: SystemSoundID = 12
                    AudioServicesPlaySystemSound(systemSoundID)
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    
                }
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
