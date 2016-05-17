//
//  CalibrateRaisedViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class CalibrateRaisedViewController: UIViewController {

    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var raisedTitleLabel: UILabel!
    @IBOutlet weak var raisedDescriptionLabel: UILabel!
    @IBOutlet weak var raisedImageView: UIImageView!
    @IBOutlet weak var recalibrateButton: UIButton! // This can be the "Start" button, and then once the user started at least once it'll become the recalibrate button
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    
    
    
    // MARK: - Actions
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        // Move to lowered phone view
    }

    @IBAction func recalibrateButtonTapped(sender: AnyObject) {
        // Begin capturing CMGryoData

        if recalibrateButton.titleLabel?.text == "Begin Calibration" {
            recalibrateButton.setTitle("Recalibrate", forState: .Normal)
        } else {
            // Delete whatever info was saved
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
