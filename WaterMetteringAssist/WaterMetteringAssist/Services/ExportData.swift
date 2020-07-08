//
//  ExportData.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 1/17/20.
//  Copyright © 2020 Ric. All rights reserved.
//

import UIKit
import CoreData

// https://stackoverflow.com/questions/40222530/how-to-export-core-data-to-csv-in-swift-3

extension CustomerViewController {
    
    @IBAction func exportData(_ sender: Any) {
        
        
        guard let custumerArray = customerArray else { return}
        
        if custumerArray.count > 0 {
            let alert = UIAlertController(title: "Export data", message: "Do you want to export all the data?", preferredStyle: .alert)
            
            let exportAction = UIAlertAction(title: "Export", style: .default) {  action in
                
                self.exportDatabase()
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(exportAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)// print("export Data")
            
        } else {
            AlertService.alert(messageString: "No data to export!", vc: self)
        }
        
    }
    
    
    
    
    func exportDatabase() {
        let exportString = createExportString()
        saveAndExport(exportString: exportString )
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "waterReadings.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    func createExportString() -> String {
        
        guard let customerArray = customerArray else { return ""}
        var export: String = NSLocalizedString("Customer Name, Address, City, ZipCode, readings, date \n", comment: "")
        
        for  customer in customerArray {
            
            //let inventoryDatevar = itemList.value(forKey: "inventoryDate") as! Date
            let customerName = customer.name
            let customerAddress = customer.address
            let customerCity = customer.city
            let customerZipCode = customer.zipCode
            
            var readingValues = String()
            if let readings = customer.monthlyReadingsArray {
                var aux = 1
                for index in readings {
                    if aux == 1 {
                        readingValues += "\(index.reading!), \(index.atDate!)"
                    } else {
                        readingValues += ", \(index.reading!), \(index.atDate!)"
                    }
                    aux += 1
                }
                
            }
            
            export += "\(customerName!),\(customerAddress!),\(customerCity!), \(customerZipCode!), \(readingValues) \n"
            readingValues.removeAll()
        }
        print("This is what the app will export: \(export)")
        return export
    }
    
    
    
    
}
