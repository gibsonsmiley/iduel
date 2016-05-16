//
//  CalibrateLoweredViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class CalibrateLoweredViewController: UIViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var loweredTitleLabel: UILabel!
    @IBOutlet weak var loweredDescriptionLabel: UILabel!
    @IBOutlet weak var loweredImageView: UIImageView!
    @IBOutlet weak var recalibrateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        // Move to set up duel view, save all calibrations
    }
    
    @IBAction func recalibrateButtonTapped(sender: AnyObject) {
        // Start calibration or recalibration
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
