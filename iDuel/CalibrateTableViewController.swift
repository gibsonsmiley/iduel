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
    
    let raisedCalibrationKey = "raisedCalibration"
    let loweredCalibrationKey = "loweredCalibration"
    
    var raisedCalibration: Calibration?
    var loweredCalibration: Calibration?
    
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
        guard let raisedCalibration = raisedCalibration else { return }
        guard let loweredCalibration = loweredCalibration else { return }
        let destinationViewController = presentingViewController as? SetUpDuelViewController
        destinationViewController?.calibrations?.append(raisedCalibration)
        destinationViewController?.calibrations?.append(loweredCalibration)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func raisedCalibrateButtonTapped(sender: AnyObject) {
        MotionController.beginMotionTracking { (averageCalibration) in
            guard let calibration = averageCalibration else { return }
            MotionController.saveCalibration("raised", userCalibration: calibration)
            self.raisedCalibration = calibration
            self.raisedTitleLabel.text = "Calibration Saved - Tap To Recalibrate"
        }
    }
    
    @IBAction func loweredCalibrateButtonTapped(sender: AnyObject) {
        MotionController.beginMotionTracking { (averageCalibration) in
            guard let calibration = averageCalibration else { return }
            MotionController.saveCalibration("lowered", userCalibration: calibration)
            self.loweredCalibration = calibration
            self.loweredTitleLabel.text = "Calibration Saved - Tap To Recalibrate"
        }
    }
    
    /* // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     } */
}
