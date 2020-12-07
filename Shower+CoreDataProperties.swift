//
//  Shower+CoreDataProperties.swift
//  ShowerTicker
//
//  Created by Steuber, Brian William on 12/7/20.
//
//

import Foundation
import CoreData


extension Shower {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shower> {
        return NSFetchRequest<Shower>(entityName: "Shower")
    }

    @NSManaged public var date: Date?
    @NSManaged public var time: String?
    @NSManaged public var totalWaterSaved: Double
    @NSManaged public var waterSaved: Double

}

extension Shower : Identifiable {

}
