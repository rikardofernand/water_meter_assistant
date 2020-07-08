//
//  MonthlyReadings+CoreDataClass.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 1/15/20.
//  Copyright © 2020 Ric. All rights reserved.
//
//

import UIKit
import CoreData

@objc(MonthlyReadings)
public class MonthlyReadings: NSManagedObject {

    
    convenience init?(reading: String?, date: Date?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {return nil}

        self.init(entity: MonthlyReadings.entity(), insertInto: context)
        
        self.reading = reading
        self.atDate = date
    }
    
}

