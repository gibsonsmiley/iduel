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
import AVFoundation
import MediaPlayer

class DuelViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fireButton: UIButton!
    
    var duel: Duel?
    var winner: User?
    var loser: User?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DuelController.duelStart(duel) { (success) in
            if success {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.volumeChanged(_:)), name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
                let frame = CGRect(x: 0, y: -100, width: 10, height: 0)
                let volumeView = MPVolumeView(frame: frame)
                volumeView.sizeToFit()
                UIApplication.sharedApplication().windows.first?.addSubview(volumeView)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: Methods
    
    func updateWithDuel(duel: Duel) {
        self.duel = duel
    }
    
<<<<<<< HEAD
    func duelStart() {
        MotionController.sharedController.checkRange(false) { (success) in
            if success {
                MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                MotionController.sharedController.checkFlick({ (success) in
                    if success {
                        if let duel = self.duel {
                            
                        }
                        
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
>>>>>>> feature/duelViewController
        
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
    
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        // Stop duel and move back to set up view
        // Possibly alert opponent that duel was cancelled
    }
    
    @IBAction func fireButtonTapped(sender: AnyObject) {
        // FIRE!
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
