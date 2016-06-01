//
//  SettingsTableViewController.swift
//  Duellum
//
//  Created by Batman on 5/18/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit
import AudioToolbox


class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var soundEffectSwitch: UISwitch!
    @IBOutlet weak var leftHandedSwitch: UISwitch!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let sounds = NSUserDefaults.standardUserDefaults().boolForKey("sounds")
    let leftHand = NSUserDefaults.standardUserDefaults().boolForKey("leftHand")
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWithPrefs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    func updateWithPrefs() {
        soundEffectSwitch.setOn(!sounds, animated: true) // Set as opposite so that it "defaults" to on
        leftHandedSwitch.setOn(leftHand, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func soundEffectSwitched(sender: AnyObject) {
        if sounds == true {
            defaults.setBool(false, forKey: "sounds")
            defaults.synchronize()
        } else {
            defaults.setBool(true, forKey: "sounds")
            defaults.synchronize()
        }
    }
    
    @IBAction func leftHandedSwitched(sender: AnyObject) {
        if leftHand == true {
            defaults.setBool(false, forKey: "leftHand")
            defaults.synchronize()
        } else {
            defaults.setBool(true, forKey: "leftHand")
            defaults.synchronize()
        }
    }
}
