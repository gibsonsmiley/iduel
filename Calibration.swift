//
//  Calibration.swift
//  Duellum
//
//  Created by mac-admin on 5/18/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import Foundation
import CoreData

@objc(Calibration)
class Calibration: NSManagedObject {

        convenience init(x: Double, y: Double, z: Double, raised: Bool, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Calibration", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.x = x
        self.y = y
        self.z = z
        self.raised = raised
    }

}
