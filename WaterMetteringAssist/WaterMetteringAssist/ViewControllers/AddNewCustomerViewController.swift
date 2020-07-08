//
//  AddNewCustomerViewController.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 1/6/20.
//  Copyright © 2020 Ric. All rights reserved.
//

import UIKit
import CoreData

class AddNewCustomerViewController: UIViewController {
    
    
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityAddressTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
 
    
    @IBOutlet weak var scrollView: UIScrollView!
   
    
    @IBAction func saveCustomertTapped(_ sender: Any) {
        persistingData()
        
    }
    

    
    var keyboardAdjst: KeyboardAdjustment?
    
    var customerToEdit: Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
       configureTextFieldDelegates()
        
        self.keyboardAdjst = KeyboardAdjustment(scrollView: scrollView)
        
        //hide the keyboard
        scrollView.keyboardDismissMode  = .interactive
        
        
        if let customerToEdit = customerToEdit {
    
            customerNameTextField.text = customerToEdit.name
            streetAddressTextField.text = customerToEdit.address
            cityAddressTextField.text = customerToEdit.city
            zipCodeTextField.text = customerToEdit.zipCode
            
        }
    }
    
    func configureTextFieldDelegates() {
        customerNameTextField.delegate = self
        streetAddressTextField.delegate = self
        cityAddressTextField.delegate = self
        zipCodeTextField.delegate = self
    }
    
    
    
    
    func persistingData () {
        
        guard let customerName = customerNameTextField.text, customerNameTextField.text != "" else {
           AlertService.alert(messageString: "Please insert customer name!", vc: self)
           // print("insert name")
            return
        }
        
        guard let customerStreetAddress = streetAddressTextField.text, streetAddressTextField.text != "" else {
            AlertService.alert(messageString: "Please insert customer address!", vc: self)
            //print("insert address")
            return
        }
        
        guard let cityAddress = cityAddressTextField.text, cityAddressTextField.text != "" else {
             AlertService.alert(messageString: "Please insert customer city address!", vc: self)
            //print("insert city address")
            return
        }
        
        guard let zipCode = zipCodeTextField.text, zipCodeTextField.text != "" else {
            AlertService.alert(messageString: "Please insert customer zip code address!", vc: self)
            print("insert zip code ")
            return
        }
        
        
       // print(customerName, customerStreetAddress, cityAddress, zipCode)
        
        // save on Core Data
        if customerToEdit != nil {
            updateCustomer(customerName: customerName, customerStreetAddress: customerStreetAddress, customerCity: cityAddress, customerZipCode: zipCode)
        }else {
            saveCustomer(customerName: customerName, customerStreetAddress: customerStreetAddress, customerCity: cityAddress, customerZipCode: zipCode)
        }
        
        
    }
    
}

extension AddNewCustomerViewController: UITextFieldDelegate {
    
    // UITextFieldsDelegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case customerNameTextField:
            streetAddressTextField.becomeFirstResponder()
        case streetAddressTextField:
            cityAddressTextField.becomeFirstResponder()
        case cityAddressTextField:
            zipCodeTextField.becomeFirstResponder()
            
        default:
            zipCodeTextField.resignFirstResponder()
            persistingData()
        }
        return true
    }
    
}


extension AddNewCustomerViewController {
    
    func saveCustomer(customerName:String, customerStreetAddress:String, customerCity: String, customerZipCode: String) {
                
        let customerToSave = Customer(customerName: customerName, customerStreetAddress: customerStreetAddress, customerCity: customerCity, customerZipCode: customerZipCode)
        
        do {
            try customerToSave?.managedObjectContext?.save()
        
            //print("saving Costumer  to core data")
            _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            AlertService.alert(messageString: "An error ocurred! Costumer not saved! Please try again! ", vc: self)
        }
        
    }
    
    
    func updateCustomer(customerName:String, customerStreetAddress:String, customerCity: String, customerZipCode: String) {
    
        guard let customerToUpdate = customerToEdit,
        let managedContext = customerToUpdate.managedObjectContext else { return}
        
        customerToUpdate.name = customerName
        customerToUpdate.address = customerStreetAddress
        customerToUpdate.city = customerCity
        customerToUpdate.zipCode = customerZipCode
        
        do {
            try managedContext.save()
            //print("updating Costumer  to core data")
             _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            AlertService.alert(messageString: "An error ocurred! Costumer not updated! Please try again! ", vc: self)
        }
    }
    
}
