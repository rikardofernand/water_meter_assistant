//
//  CostumerDetailsViewController.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 1/6/20.
//  Copyright © 2020 Ric. All rights reserved.
//

import UIKit
import CoreData

class CostumerDetailsViewController: UIViewController , UITableViewDelegate{
    
    @IBOutlet weak var customerNameDisplay: UILabel!
    
    @IBOutlet weak var customerAddress: UILabel!
    
    @IBOutlet weak var customerCity: UILabel!
    @IBOutlet weak var customerZipCodeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var customerDetails : Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print("viewDidLoad customer details")
        
        tableView?.delegate=self
        tableView?.dataSource=self
        self.tableView?.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customerNameDisplay.text = customerDetails?.name
        
        customerAddress.text = customerDetails?.address
        
        if let customerDetailsZipCode = customerDetails?.zipCode,  let customerDetailsCity = customerDetails?.city {
            customerCity.text =  customerDetailsZipCode + ", " + customerDetailsCity
            
        }
        
        
        guard let monthlyReadingsArray = self.customerDetails?.monthlyReadingsArray else { return}
        if monthlyReadingsArray.count > 0 {
            self.tableView?.isHidden = false
            
        } else {
            self.tableView?.isHidden = true
        }
        
        self.tableView?.reloadData()
    }
    
    
  
    @IBAction func addReadingMeasurement(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Reading", message: "Add a new reading", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first,  textField.text != "" , let readToSave = textField.text else {
                //print("Empty reading")
                AlertService.alert(messageString: "Empty reading", vc: self)
                return
            }
            
            guard  CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: readToSave)) else {
                AlertService.alert(messageString: "Invalid reading measurement format: Insert only Numbers", vc: self)
                return
            }
            
            self.saveReading(read: readToSave)
            
            guard let monthlyReadingsArray = self.customerDetails?.monthlyReadingsArray else { return}
            if monthlyReadingsArray.count > 0 {
                self.tableView?.isHidden = false
                
            } else {
                self.tableView?.isHidden = true
            }
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
}


extension CostumerDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(customerDetails?.readingsArray?.count)
        
        return customerDetails?.monthlyReadingsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "readingCellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "readingCellIdentifier")
        }
        
        let reading = customerDetails?.monthlyReadingsArray?[indexPath.row].reading
        guard let unwrappedRead = reading else {return cell!}
        cell?.textLabel?.text = "\(unwrappedRead) cubic meters"
        
        let savedAt = customerDetails?.monthlyReadingsArray?[indexPath.row].atDate
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        guard savedAt != nil else {return cell!}
        let formattedCurrentData = formatter.string(from: savedAt!)
        //print(formattedCurrentData)
        cell?.detailTextLabel?.text = formattedCurrentData
        
        return cell!
        
    }
        // delete reading
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete else {return}

           //print(reading)
            deleteReading(at: indexPath)
    
            guard let monthlyReadingsArray = self.customerDetails?.monthlyReadingsArray else { return}
            if monthlyReadingsArray.count > 0 {
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
            }
    
            self.tableView.reloadData()
    
       }
    
}

extension CostumerDetailsViewController {

    // save readings
    func saveReading(read: String) {
        let date  = Date()
        // establish the relationship
        if let readingToSave = MonthlyReadings(reading: read, date: date) {
            customerDetails?.addToRawMonthlyReadings(readingToSave)
            
            do {
                try readingToSave.managedObjectContext?.save()
              
            } catch let error as NSError {
                AlertService.alert(messageString: "An error ocurred! Reading not saved! Please try again!", vc: self)
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
        
    }
    
    // Delete readings
    func deleteReading(at indexPath:  IndexPath){
        
        guard let readingToDelete = customerDetails?.monthlyReadingsArray?[indexPath.row],
            let managedContext = readingToDelete.managedObjectContext else { return}
            
        managedContext.delete(readingToDelete)
        do {
            try managedContext.save()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // print("Reading deleted")
        } catch {
            print("Failed to delete data: ", error.localizedDescription)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        
    }
    
    
}

// MARK: - Navigation
extension CostumerDetailsViewController {
    
      // passing data 
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          //if segue.destination is customerDetails
          if let vc = segue.destination as? AddNewCustomerViewController
          {
            vc.customerToEdit = customerDetails
          }
      }
}
