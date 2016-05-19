//
//  Calibration+CoreDataProperties.swift
//  Duellum
//
//  Created by mac-admin on 5/18/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Calibration {

    @NSManaged var x: NSNumber?
    @NSManaged var y: NSNumber?
    @NSManaged var z: NSNumber?

}
