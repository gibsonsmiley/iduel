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
        
        displayInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    func displayInfo() {
        let raisedKey = NSUserDefaults.standardUserDefaults().valueForKey(raisedCalibrationKey)
        let loweredKey = NSUserDefaults.standardUserDefaults().valueForKey(loweredCalibrationKey)
        
        if raisedKey != nil {
            raisedCalibrateButton.setTitle("Calibration Saved - Tap To Redo", forState: .Normal)
        }
        
        if loweredKey != nil {
            loweredCalibrateButton.setTitle("Calibration Saved - Tap To Redo", forState: .Normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
//        guard let destinationVCNavController = presentingViewController as? UINavigationController,
//        destinationViewController = destinationVCNavController.childViewControllers[1] as? SetUpDuelViewController else { return }
//        guard let raisedCalibration = self.raisedCalibration else { return }
//        guard let loweredCalibration = self.loweredCalibration else { return }
//        let raised = Calibration(x: Double(raisedCalibration.x!), y: Double(raisedCalibration.y!), z: Double(raisedCalibration.z!))
//        let lowered = Calibration(x: Double(loweredCalibration.x!), y: Double(loweredCalibration.y!), z: Double(loweredCalibration.z!))
//        destinationViewController.getCalibrations(raised, lowered: lowered)
//        print("\(destinationViewController.calibrations)")
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func raisedCalibrateButtonTapped(sender: AnyObject) {
        self.raisedCalibrateButton.setTitle("Calibrating...", forState: .Normal)
        MotionController.sharedController.beginMotionTracking { (averageCalibration) in
            guard let calibration = averageCalibration else { return }
            MotionController.sharedController.saveCalibration("raised", userCalibration: calibration)
            self.raisedCalibration = calibration
            self.raisedCalibrateButton.setTitle("Calibration Saved - Tap To Redo", forState: .Normal)
        }
    }
    
    @IBAction func loweredCalibrateButtonTapped(sender: AnyObject) {
        self.loweredCalibrateButton.setTitle("Calibrating...", forState: .Normal)
        MotionController.sharedController.beginMotionTracking { (averageCalibration) in
            guard let calibration = averageCalibration else { return }
            MotionController.sharedController.saveCalibration("lowered", userCalibration: calibration)
            self.loweredCalibration = calibration
            self.loweredCalibrateButton.setTitle("Calibration Saved - Tap To Redo", forState: .Normal)
        }
    }
    
    /* // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     } */
}
