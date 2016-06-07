//
//  IntructionPageViewController.swift
//  Duellum
//
//  Created by Batman on 6/7/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class InstructionPageViewController: UIPageViewController {

    
    let first = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RuleViewController")
    let second = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DisclaimerViewController")
    
    
    var firstRun: Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("firstRun")
    }
    
    var orderedViewControllers: [UIViewController] {
        return [first, second]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        if let firstVC = orderedViewControllers.first {
            setViewControllers([firstVC], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(name)ViewController")
    }
    
}

extension InstructionPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}
