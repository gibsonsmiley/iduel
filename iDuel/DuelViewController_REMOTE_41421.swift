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
        
        leftHandGun()
        
        DuelController.duelStart(duel) { (success) in
            if success {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.volumeChanged(_:)), name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
                let frame = CGRect(x: 0, y: -100, width: 10, height: 0)
                let volumeView = MPVolumeView(frame: frame)
                volumeView.sizeToFit()
                UIApplication.sharedApplication().windows.first?.addSubview(volumeView)
            } else {
                print("not shooting for some reason")
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
    
    func leftHandGun() {
        let leftHand = NSUserDefaults.standardUserDefaults().boolForKey("leftHand")
        if leftHand == true {
            self.fireButton.setImage(UIImage(named: "LH Duel View"), forState: .Normal)
        } else {
            self.fireButton.setImage(UIImage(named: "RH Duel View"), forState: .Normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
                    SystemSoundID.playGunShot1("1gunshot", withExtenstion: "mp3")
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
