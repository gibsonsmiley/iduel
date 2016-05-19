//
//  CalibrateTableViewController.swift
//  Duellum
//
//  Created by Gibson Smiley on 5/19/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit
import CoreMotion

class CalibrateTableViewController: UITableViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var viewDescriptionLabel: UILabel!
    @IBOutlet weak var raisedTitleLabel: UILabel!
    @IBOutlet weak var raisedDescriptionLabel: UILabel!
    @IBOutlet weak var raisedCalibrateButton: UIButton!
    @IBOutlet weak var loweredTitleLabel: UILabel!
    @IBOutlet weak var loweredDescriptionLabel: UILabel!
    @IBOutlet weak var loweredCalibrateButton: UIButton!
    
    var raisedCalibration: CMRotationRate?
    var loweredCalibration: CMRotationRate?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods

    
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        // Ensure calibrations are saved
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func raisedCalibrateButtonTapped(sender: AnyObject) {
        // Get calibration and save it
        if raisedCalibrateButton.titleLabel?.text == "Begin Calibration" {
            if raisedCalibration != nil {
                raisedCalibrateButton.setTitle("Recalibrate", forState: .Normal)
                raisedTitleLabel.text = "Phone Raised - Calibration Saved"
            } else {
                raisedTitleLabel.text = "Phone Raised"
            }
        } else {
            raisedCalibrateButton.setTitle("Begin Calibration", forState: .Normal)
        }
    }
    
    @IBAction func loweredCalibrateButtonTapped(sender: AnyObject) {
        // Get calibration and save it
        if loweredCalibrateButton.titleLabel?.text == "Begin Calibration" {
            if loweredCalibration != nil {
                loweredCalibrateButton.setTitle("Recalibrate", forState: .Normal)
                loweredTitleLabel.text = "Phone Lowered - Calibration Saved"
            } else {
                loweredTitleLabel.text = "Phone Lowered"
            }
        } else {
            loweredCalibrateButton.setTitle("Begin Calibration", forState: .Normal)
        }
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
