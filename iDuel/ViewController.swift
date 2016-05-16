//
//  ViewController.swift
//  iDuel
//
//  Created by Gibson Smiley on 5/16/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var now = NSDate()
    var fireDate: NSDate? {
        didSet {
            prepareForDuel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        fire()
    }
    
    func fire() {
        let date = NSDate()
        
        let fireDate = date.dateByAddingTimeInterval(NSTimeInterval(3.0))
        
        FirebaseController.base.childByAppendingPath("duel").setValue(fireDate.timeIntervalSince1970)

        
    }
    
//    func setFireDate(date: NSDate) {
//        FirebaseController.base.childByAppendingPath("duel").observeEventType(.Value, withBlock: { (snapshot) in
//            <#code#>
//        })
//    }
    
    func prepareForDuel() {
        guard let fireDate = fireDate else {return}
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC)*fireDate.timeIntervalSinceNow)), dispatch_get_main_queue()) {
            // Anything in here will happen when the fireDate arrives
        }
    }
    
//    func check() {
//        //        FirebaseController.base.childByAppendingPath("duel").observeEventType(.Value, withBlock: { (snapshot) in
//        FirebaseController.observeDataAtEndpoint("duel") { (data) in
//            NSThread.sleepForTimeInterval(3.0)
//            let now = NSDate().timeIntervalSince1970
//            print("now: \(now)")
//            print("snapshot value: \(data)")
//            guard let dateData = data as? NSTimeInterval else { return }
//            
//            let fireDate = NSDate(timeIntervalSince1970: dateData)
//            print("checked firedate:\(fireDate)")
//            
//            if now == dateData {
//                
//            }
//            if now.compare(fireDate) == .OrderedDescending {
//                self.label.text = "It worked"
//                
//            }
//        }
//    }
}

