//
//  MonthlyReadings+CoreDataProperties.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 1/17/20.
//  Copyright © 2020 Ric. All rights reserved.
//
//

import Foundation
import CoreData


extension MonthlyReadings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MonthlyReadings> {
        return NSFetchRequest<MonthlyReadings>(entityName: "MonthlyReadings")
    }

    @NSManaged public var atDate: Date?
    @NSManaged public var reading: String?
    @NSManaged public var customer: Customer?

}
