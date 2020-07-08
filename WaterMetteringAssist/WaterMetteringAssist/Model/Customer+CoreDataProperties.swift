//
//  Customer+CoreDataProperties.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 1/17/20.
//  Copyright © 2020 Ric. All rights reserved.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var name: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var rawMonthlyReadings: NSOrderedSet?

}

// MARK: Generated accessors for rawMonthlyReadings
extension Customer {

    @objc(insertObject:inRawMonthlyReadingsAtIndex:)
    @NSManaged public func insertIntoRawMonthlyReadings(_ value: MonthlyReadings, at idx: Int)

    @objc(removeObjectFromRawMonthlyReadingsAtIndex:)
    @NSManaged public func removeFromRawMonthlyReadings(at idx: Int)

    @objc(insertRawMonthlyReadings:atIndexes:)
    @NSManaged public func insertIntoRawMonthlyReadings(_ values: [MonthlyReadings], at indexes: NSIndexSet)

    @objc(removeRawMonthlyReadingsAtIndexes:)
    @NSManaged public func removeFromRawMonthlyReadings(at indexes: NSIndexSet)

    @objc(replaceObjectInRawMonthlyReadingsAtIndex:withObject:)
    @NSManaged public func replaceRawMonthlyReadings(at idx: Int, with value: MonthlyReadings)

    @objc(replaceRawMonthlyReadingsAtIndexes:withRawMonthlyReadings:)
    @NSManaged public func replaceRawMonthlyReadings(at indexes: NSIndexSet, with values: [MonthlyReadings])

    @objc(addRawMonthlyReadingsObject:)
    @NSManaged public func addToRawMonthlyReadings(_ value: MonthlyReadings)

    @objc(removeRawMonthlyReadingsObject:)
    @NSManaged public func removeFromRawMonthlyReadings(_ value: MonthlyReadings)

    @objc(addRawMonthlyReadings:)
    @NSManaged public func addToRawMonthlyReadings(_ values: NSOrderedSet)

    @objc(removeRawMonthlyReadings:)
    @NSManaged public func removeFromRawMonthlyReadings(_ values: NSOrderedSet)

}
