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
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var soundEffectSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBOutlet weak var leftHandedSwitch: UISwitch!
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func soundEffectSwitched(sender: AnyObject) {
        if soundEffectSwitch.on == true {
            defaults.setBool(true, forKey: "sounds")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else if soundEffectSwitch.on == false {
            defaults.setBool(false, forKey: "sounds")
        }
        
    }
    
    
    @IBAction func vibrationSwitched(sender: AnyObject) {
        if vibrationSwitch.on == true {
            defaults.setBool(true, forKey: "vibrate")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else if vibrationSwitch.on == false {
            defaults.setBool(false, forKey: "vibrate")
        }
        
    }
    
    @IBAction func leftHandedSwitched(sender: AnyObject) {
        if leftHandedSwitch.on == true {
            defaults.setBool(true, forKey: "leftHand")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else if leftHandedSwitch.on == false {
            defaults.setBool(false, forKey: "leftHand")
            
        }
        
    }
    
    
    
//    func vibrate() {
//        if NSUserDefaults.standardUserDefaults().boolForKey("vibrate") == true {
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        }
//    }
    
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
