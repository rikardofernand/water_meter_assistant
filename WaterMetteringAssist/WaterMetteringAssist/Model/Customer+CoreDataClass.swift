//
//  Customer+CoreDataClass.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 1/15/20.
//  Copyright © 2020 Ric. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Customer)
public class Customer: NSManagedObject {


    var  monthlyReadingsArray : [MonthlyReadings]? {
        return self.rawMonthlyReadings?.array as? [MonthlyReadings]
    }

    convenience init?(customerName: String, customerStreetAddress: String, customerCity: String, customerZipCode: String)  {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {return nil}
        
        self.init(entity: Customer.entity(), insertInto: context)
        
        self.address = customerStreetAddress
        self.city = customerCity
        self.name = customerName
        self.zipCode = customerZipCode
        
    }
}
