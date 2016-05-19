//
//  CalibrateTableViewController.swift
//  Duellum
//
//  Created by Gibson Smiley on 5/19/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
    }
    @IBAction func raisedCalibrateButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func loweredCalibrateButtonTapped(sender: AnyObject) {
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
