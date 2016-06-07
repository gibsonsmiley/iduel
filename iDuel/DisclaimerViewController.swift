//
//  DisclaimerViewController.swift
//  Duellum
//
//  Created by Batman on 6/7/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func beginButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstRun")
    }
    
}
