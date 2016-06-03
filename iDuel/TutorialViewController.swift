//
//  TutorialViewController.swift
//  Duellum
//
//  Created by Gibson Smiley on 5/31/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var transitionButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.secondLabel.text = "Once the duel has begun, lower your phone by your waist, as if it's holstered."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning on \(self)")
    }
    
    // MARK: - Methods
    
    
    // MARK: - Actions
    
    @IBAction func buttonTapped(sender: AnyObject) {
        self.secondLabel.slideLeft()
        self.secondLabel.text = "Then, flick or shake your phone to indicate you're ready. \n\nOnce both duelers have done this, the countdown begins."
        self.transitionButton.hidden = true
        self.secondButton.hidden = false
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        self.secondLabel.slideLeft()
        self.secondLabel.text = "When the countdown ends your phone will vibrate and the first to raise their gun and fire wins! \n\nYou can fire your gun by tapping the screen or pressing a volume button."
        self.secondButton.setTitle("Done", forState: .Normal)
        self.secondButton.hidden = true
        self.doneButton.hidden = false
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UIView {
    
    func slideLeft(duration: NSTimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        let slideLeftTransition = CATransition()
        if let delegate: AnyObject = completionDelegate {
            slideLeftTransition.delegate = delegate
        }
        
        slideLeftTransition.type = kCATransitionPush
        slideLeftTransition.subtype = kCATransitionFromRight
        slideLeftTransition.duration = duration
        slideLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideLeftTransition.fillMode = kCAFillModeRemoved
        
        self.layer.addAnimation(slideLeftTransition, forKey: "slideLeftTransition")
    }
}