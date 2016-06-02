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
        self.fireButton.enabled = false
        DuelController.duelStart(duel) { (duel, success) in
            guard let duel = duel else { return }
            if success {
                DuelController2.observeReadyStatuses(duel, completion: { (playersReady) in
                    print("Players ready: \(playersReady)")
                    if playersReady == true {
                        // Countdown starts
                        //                        DuelController2.observeCountdown(duel, completion: { (countdown) in
                        //                            if let countdown = countdown {
                        self.duel = duel
                        //                                print("Countdown: \(countdown) seconds")
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
                        print("countdown nil")
                    }
                    
                    //                        })
                    //                    }
                })
            } else {
                print("not shooting for some reason")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Methods
    
    func updateWithDuel(duel: Duel) {
        self.duel = duel
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        // Stop duel and move back to set up view
        // Possibly alert opponent that duel was cancelled
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
            guard let duel = duel else { return }
            if winner != nil {
                destinationViewController.updateWithDuel(duel, victory: "winner")
            } else if loser != nil {
                destinationViewController.updateWithDuel(duel, victory: "loser")
            }
            _ = destinationViewController.view
        }
    }
    
    func finishDuel() {
        SystemSoundID.playGunShot1("1gunshot", withExtenstion: "mp3")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        guard let duel = self.duel else { return }
        guard let currentUser = UserController.sharedController.currentUser else { return }
        DuelController2.sendShotToDuel(duel, user: currentUser, completion: { (success) in
            if success {
                DuelController2.observeShotsFired(duel, completion: { (winner, loser) in
                    guard let winner = winner, loser = loser else {
                        print("winner not determined")
                        return
                    }
                    self.winner = winner
                    self.loser = loser
                    print("Winner: \(winner.nickname) Loser: \(loser.nickname) on View")
                })
            } else {
                print("shot not sent to duel")
            }
        })
    }
}
