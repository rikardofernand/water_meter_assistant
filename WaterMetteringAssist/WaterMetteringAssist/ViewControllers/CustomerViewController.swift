//
//  ViewController.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 12/21/19.
//  Copyright © 2019 Ric. All rights reserved.
//

import UIKit
import CoreData

//Global variables
let appDelegateGlobal = UIApplication.shared.delegate as? AppDelegate

class CustomerViewController: UIViewController {
    
    var customerArray : [Customer]?
    var selectedCustomer : Customer?
    var searchCustomerArray  = [Customer]()
    var searching = false
    
    @IBOutlet weak var searchCustomer: UISearchBar!
    
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var tableView:UITableView!
    
    
    @IBAction func deleteAllData(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete all the data", message: "Do you want to delete all data?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) {  action in
            
            self.deleteAllData()
            //print("Delete all")
            self.fetchCustomer()
            self.tableView?.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    @IBOutlet weak var seachBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCustomer()
        guard let custumerArray = customerArray else { return}
        if custumerArray.count > 0 {
            tableView?.isHidden = false
            searchCustomer?.isHidden = false
        } else {
            tableView?.isHidden = true
            searchCustomer?.isHidden = true
        }
        
        self.tableView?.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        self.tableView?.reloadData()
        
    }
}


extension CustomerViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchCustomerArray.count
            
        } else {
            if let customerArray = customerArray {
                return customerArray.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "readingcellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "readingcellIdentifier")
        }
        
        if searching {
            cell?.textLabel?.text = searchCustomerArray[indexPath.row].name
            cell?.detailTextLabel?.text = searchCustomerArray[indexPath.row].address
        } else {
            customerArray?.sort{
                $0.name!.lowercased() < $1.name!.lowercased()
            }
            
            cell?.textLabel?.text = customerArray?[indexPath.row].name
            cell?.detailTextLabel?.text = customerArray?[indexPath.row].address
        }
        
        cell!.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell!
    }
    
    
    // Delele customer
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return}
        
        if self.searching {
            self.deleteCustomer(at: indexPath)
            
        }else {
            self.deleteCustomer(at: indexPath)
            //self.fetchCustomer()
        }
        
        if let custumerArray = self.customerArray  {
            if custumerArray.count > 0 {
                tableView.isHidden = false
                self.searchCustomer.isHidden = false
            } else {
                tableView.isHidden = true
                self.searchCustomer.isHidden = true
            }
        }
    }
    
}


extension CustomerViewController {
    
    // fetch the custumer data
    func fetchCustomer() {
        guard let managedContext = appDelegateGlobal?.persistentContainer.viewContext else { return}
        
        let fetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
        
        do {
            customerArray = try managedContext.fetch(fetchRequest) //as? [Customer]
            // print("is requesting costumer")
            //tableView?.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            AlertService.alert(messageString: "An error ocurred! Costumers not fetched! Please try again! ", vc: self)
        }
        
    }
    
    // Delete custumer
    func deleteCustomer(at indexPath:  IndexPath) {
        
        if searching {
            let customerToDelete = self.searchCustomerArray[indexPath.row]
            guard let managedContext = customerToDelete.managedObjectContext else { return}
            
            managedContext.delete(customerToDelete)
            
            do {
                try managedContext.save()
                //print("filtered customer deleted")
                searchCustomerArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                fetchCustomer()
                tableView.reloadData()
            } catch {
                print("Failed to delete data: ", error.localizedDescription)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                AlertService.alert(messageString: "An error ocurred! Costumer not deleted! Please try again! ", vc: self)
            }
        } else {
            guard let customerToDelete = self.customerArray?[indexPath.row],
                let managedContext = customerToDelete.managedObjectContext else { return}
            
            managedContext.delete(customerToDelete)
            
            do {
                try managedContext.save()
                // print("customer deleted")
                customerArray?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Failed to delete data: ", error.localizedDescription)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                AlertService.alert(messageString: "An error ocurred! Costumer not deleted! Please try again! ", vc: self)
            }
        }
        
    }
    
    
    // delete all the data
    func deleteAllData() {
        
        guard let managedContext = appDelegateGlobal?.persistentContainer.viewContext else { return}
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Customer")
        
        do {
            let objects = try managedContext.fetch(fetchRequest) as! [Customer]
            for object in objects {
                managedContext.delete(object)
            }
            
            try managedContext.save()
            //print("deleting all the costumers")
            view.endEditing(true)
            tableView?.isHidden = true
            searchCustomer?.isHidden = true
        } catch let error as NSError {
            print("Could not Delete Customers. \(error), \(error.userInfo)")
            AlertService.alert(messageString: "An error ocurred! Costumers not deleted! Please try again! ", vc: self)
        }
    }
    
    
    
}

// MARK: - Search Bar
extension CustomerViewController: UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let customerArray = customerArray else {
            return
        }
        
        searchCustomerArray = customerArray.filter({$0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased()})
        //print(searchCustomerArray)
        searching = true
        tableView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if searchBar.text == "" {
            searching = false
        }
        tableView?.reloadData()
        searchBar.showsCancelButton = true
        //print("search pressed")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.endEditing(true)
        tableView?.reloadData()
        
    }
    
    
}


// MARK: - Navigation
extension CustomerViewController {
    @IBAction func newCustomerButton(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "segueAddNewCustomer", sender: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.selectedCustomer = customerArray?[indexPath.row]
        //print(selectedCustomer)
        
        // segue to move to the next page after login
        self.performSegue(withIdentifier: "segueCustumerDetails", sender: nil)
    }
    
    
    // send costumer data to the CostumerDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CostumerDetailsViewController
        {
            vc.customerDetails = selectedCustomer!
        }
        
    }
    
    
}


