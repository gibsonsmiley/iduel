//
//  SettingsTableViewController.swift
//  Duellum
//
//  Created by Batman on 5/18/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit


class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var soundEffectSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBOutlet weak var leftHandedSwitch: UISwitch!
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func soundEffectSwitched(sender: AnyObject) {
        if soundEffectSwitch.on == true {
            defaults.setBool(true, forKey: "sounds")
            NSUserDefaults.standardUserDefaults().boolForKey("sounds")
        } else if soundEffectSwitch.on == false {
            defaults.setBool(false, forKey: "sounds")
            NSUserDefaults.standardUserDefaults().boolForKey("sounds")
        }
    }
    
    @IBAction func vibrationSwitched(sender: AnyObject) {
        if vibrationSwitch.on == true {
            defaults.setBool(true, forKey: "vibrate")
            NSUserDefaults.standardUserDefaults().boolForKey("vibrate")
        } else if vibrationSwitch.on == false {
            defaults.setBool(false, forKey: "vibrate")
            NSUserDefaults.standardUserDefaults().boolForKey("vibrate")
        }
    }
    
    @IBAction func leftHandedSwitched(sender: AnyObject) {
        if leftHandedSwitch.on == true {
            defaults.setBool(true, forKey: "leftHand")
            NSUserDefaults.standardUserDefaults().boolForKey("lefthand")
        } else if leftHandedSwitch.on == false {
            defaults.setBool(false, forKey: "leftHand")
            NSUserDefaults.standardUserDefaults().boolForKey("lefthand")
        }
    }
    
//    func vibrate() {
//        if NSUserDefaults.standardUserDefaults().boolForKey("vibrate") == true {
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        }
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
