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
        playDuelBackGroundMusic("DuelTrack")
        self.fireButton.enabled = false
        DuelController.duelStart(duel) { (duel, success) in
            guard let duel = duel else { return }
            if success {
                DuelController.observeReadyStatuses(duel, completion: { (playersReady) in
                    print("Players ready: \(playersReady)")
                    if playersReady == true {
                        
                        self.duel = duel
                        print("Countdown initiated \(NSDate())")
                        sleep(UInt32(4))
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        
                        // User raises device, checks to see if in the correct range
                        MotionController.sharedController.checkRange(true, completion: { (success) in
                            if success {
                                
                                MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
                                self.fireButton.enabled = true
                                let frame = CGRect(x: 0, y: -100, width: 10, height: 0)
                                let volumeView = MPVolumeView(frame: frame)
                                volumeView.sizeToFit()
                                UIApplication.sharedApplication().windows.first?.addSubview(volumeView)
                                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.volumeChanged(_:)), name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
                            } else {
                                print("gun not in range to shoot")
                            }
                            
                        })
                        
                    } else {
                        print("one players not ready")
                    }
                    
                })
            } else {
                print("not shooting for some reason")
            }
        }
        
        let leftHanded = NSUserDefaults.standardUserDefaults().boolForKey("leftHand")
        if leftHanded == true {
            self.fireButton.setImage(UIImage(named: "LH Duel View"), forState: .Normal)
        } else {
            self.fireButton.setImage(UIImage(named: "RH Duel View"), forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Methods
    
    func updateWithDuel(duel: Duel) {
        self.duel = duel
    }
    
    func finishDuel() {
        SystemSoundID.playGunShot1("1gunshot", withExtenstion: "mp3")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        guard let duel = self.duel else { return }
        guard let currentUser = UserController.sharedController.currentUser else { return }
        //        DuelController.shoot(duel, user: currentUser) { (success) in
        //            if success == true {
        //                DuelController.watchShots(duel, completion: { (winner, loser) in
        //                    guard let winner = winner,
        //                        loser = loser else { return }
        //                    self.winner = winner
        //                    self.loser = loser
        //                    print("Winner: \(winner.nickname) Loser: \(loser.nickname) on View")
        //                    self.performSegueWithIdentifier("toVictory", sender: self)
        //                })
        //            }
        //        }
        DuelController.sendShotToDuel(duel, user: currentUser, completion: { (success) in
            if success {
                DuelController.observeShotsFired(duel, completion: { (winner, loser) in
                    guard let winner = winner, loser = loser else {
                        print("winner not determined")
                        return
                    }
                    self.winner = winner
                    self.loser = loser
                    print("Winner: \(winner.nickname) Loser: \(loser.nickname) on View")
                    self.performSegueWithIdentifier("toVictory", sender: self)
                })
            } else {
                print("shot not sent to duel")
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("backToSetup", sender: self)
        MotionController.sharedController.motionManager.stopDeviceMotionUpdates()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
    }
    
    @IBAction func fireButtonTapped(sender: AnyObject) {
        finishDuel()
    }
    
    func volumeChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    finishDuel()
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toVictory" {
            guard let destinationViewController = segue.destinationViewController as?  VictoryViewController else { return }
            guard let winner = self.winner,
                loser = self.loser,
                duel = self.duel else { return }
            destinationViewController.updateWithDuel(duel, winner: winner, loser: loser)
            _ = destinationViewController.view
        }
    }
    
}
