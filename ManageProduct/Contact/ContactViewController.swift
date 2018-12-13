//
//  ContactViewController.swift
//  ManageProduct
//
//  Created by NXA on 8/31/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var peopleArray = [People]()
    var filterPeople = [People]()
    var index = NSIndexPath()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItem()
        if(peopleArray.count > 0) {
            selectRowAtZero()
            NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadType"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadData"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loadUpdateData), name: NSNotification.Name(rawValue: "loadUpdateData"), object: nil)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadData"), object: nil)
        if(!peopleArray.isEmpty) {
            tableView.selectRow(at: index as IndexPath, animated: true, scrollPosition: .none)
            tableView(tableView, didSelectRowAt: index as IndexPath)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func selectRowAtZero() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath as IndexPath)
    }
    
    @objc func loadList(){
        peopleArray.removeAll()
        loadDataByType(type: UserDefaults.standard.string(forKey: "key_Value")!)
        self.tableView.reloadData()
        let indexPath = NSIndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath as IndexPath)
    }
    
    @objc func loadData(){ //add new
        loadItem()
        self.tableView.reloadData()
        let indexPath = NSIndexPath(row: peopleArray.count - 1, section: 0)
        tableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath as IndexPath)
    }
    
    @objc func loadUpdateData(){
        loadItem()
        tableView.reloadData()
        tableView.selectRow(at: index as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: index as IndexPath)
    }
    
    private func setUpNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Tìm kiếm..."
    }
    
    private func filterContent(searchText: String, scope: String = "All") {
        filterPeople = peopleArray.filter { people in
            if(searchText == "") {
                return true
            }
            return (people.name?.contains(searchText))!
        }
        tableView.reloadData()
    }
    
    private func saveItem() {
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Error save")
        }
    }
    
    public func loadDataByType(type: String) {
        if(type == "Tất cả") {
            loadItem()
        } else {
            do {
                let fetchRequest : NSFetchRequest<People> = People.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "type == %@", type)
                let fetchedResults = try context.fetch(fetchRequest)
                for result in fetchedResults {
                    peopleArray.append(result)
                }
            } catch {
                print("Error")
            }
        }
    }
    
    private func loadItem() {
        let request: NSFetchRequest<People> = People.fetchRequest()
        do {
            peopleArray = try context.fetch(request)
        } catch {
            print("Error reload data")
        }
    }
    
    @IBAction func btnAddNew(_ sender: Any) {}
    
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive && searchController.searchBar.text != "") {
            return filterPeople.count
        }
        return peopleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ContactTableViewCell", owner: self, options: nil)?.first as! ContactTableViewCell
        if(searchController.isActive && searchController.searchBar.text != "") {
            cell.titleLabel?.text = filterPeople[indexPath.row].name
        } else {
            cell.titleLabel?.text = peopleArray[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(searchController.isActive && searchController.searchBar.text != "") {
                var empId = ""
                empId = (filterPeople[indexPath.row].id)!
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "People")
                let predicate = NSPredicate(format: "id = '\(empId)'")
                fetchRequest.predicate = predicate
                let objects = try! context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object as! NSManagedObject)
                }
                saveItem()
                self.filterPeople.remove(at: indexPath.row)
                self.peopleArray.remove(at: indexPath.row + 1)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                if(peopleArray.count > 0) {
                    selectRowAtZero()
                }
            } else {
                var empId = ""
                empId = (peopleArray[indexPath.row].id)!
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "People")
                let predicate = NSPredicate(format: "id = '\(empId)'")
                fetchRequest.predicate = predicate
                let objects = try! context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object as! NSManagedObject)
                }
                saveItem()
                self.peopleArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                if(peopleArray.count > 0) {
                    selectRowAtZero()
                }
            }
        } else if editingStyle == .insert {

        }
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: indexPath)
        index = indexPath as NSIndexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {       
        if(segue.identifier == "showDetail") {
            let row =  (sender as! NSIndexPath).row
            if(searchController.isActive && searchController.searchBar.text != "") {
                if let destinationVC = segue.destination as? DetailContactViewController {
                    destinationVC.id = filterPeople[row].id
                    destinationVC.name = filterPeople[row].name
                    destinationVC.phone = filterPeople[row].phone
                    destinationVC.card = filterPeople[row].card
                    destinationVC.cardDate = filterPeople[row].cardDate
                    destinationVC.bankCode = filterPeople[row].bankCode
                    destinationVC.bankLocation = filterPeople[row].bankLocation
                    destinationVC.type = filterPeople[row].type
                    destinationVC.product = filterPeople[row].product
                }
            } else {
                if let destinationVC = segue.destination as? DetailContactViewController {
                    if row > -1 {
                        destinationVC.id = peopleArray[row].id
                        destinationVC.name = peopleArray[row].name
                        destinationVC.phone = peopleArray[row].phone
                        destinationVC.card = peopleArray[row].card
                        destinationVC.cardDate = peopleArray[row].cardDate
                        destinationVC.bankCode = peopleArray[row].bankCode
                        destinationVC.bankLocation = peopleArray[row].bankLocation
                        destinationVC.type = peopleArray[row].type
                        destinationVC.product = peopleArray[row].product
                    }
                }
            }
        } else if(segue.identifier == "showAddNew") {
            _ = segue.destination as? AddNewViewController
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}















