//
//  TopDownSegue.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class TopDownSegue: UIStoryboardSegue {
    override func perform() {
        super.perform()
        
        let vc1 = self.sourceViewController.view as UIView
        let vc2 = self.destinationViewController.view as UIView
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(vc1, aboveSubview: vc2)
        
        UIView.animateWithDuration(0.1, animations: {
            self.sourceViewController.navigationController?.navigationBarHidden = true
            vc1.frame = CGRectOffset(vc1.frame, 0.0, screenHeight)
            vc2.frame = CGRectOffset(vc2.frame, 0.0, screenHeight)
        }) { (Finished) in
            self.sourceViewController.presentViewController(self.destinationViewController as UIViewController, animated: false, completion: nil)
            self.sourceViewController.navigationController?.navigationBarHidden = false
        }
    }
}
