//
//  WelcomeViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var toSetUpButton: UIButton!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    
    
    // MARK: - Actions
    
    @IBAction func toSetUpButtonTapped(sender: AnyObject) {
        errorLabel.hidden = true
        if nicknameTextField.text != "" {
            performSegueWithIdentifier("toSetUpDuel", sender: self)
            // Create new temporary user
            // Move to set up view
        } else {
            errorLabel.hidden = false
            errorLabel.text = "You need to pick a nickname before continuing."
            // Display a message saying a nickname is required
        }
    }
    
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("toSettings", sender: self)
        // Display settings
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
