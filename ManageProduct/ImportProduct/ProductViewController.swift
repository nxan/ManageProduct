//
//  ProductViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/11/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {

    var productArray = [Product]()
    var filterProduct = [Product]()
    let searchController = UISearchController(searchResultsController: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var index = NSIndexPath()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        loadItem()
        if(productArray.count > 0) {
            selectRowAtZero()
            NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadData"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loadUpdateData), name: NSNotification.Name(rawValue: "loadUpdateData"), object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadData"), object: nil)
        if(!productArray.isEmpty) {
            tableView.selectRow(at: index as IndexPath, animated: true, scrollPosition: .none)
            tableView(tableView, didSelectRowAt: index as IndexPath)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        searchController.searchBar.scopeButtonTitles = ["Tất cả", "Nhập hàng", "Bán hàng"]
        searchController.searchBar.delegate = self
    }
    
    private func filterContent(searchText: String) {
        filterProduct = productArray.filter { product in
            if(searchText == "") {
                return true
            }
            return (product.productName?.contains(searchText))!
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
    
    private func loadItem() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            productArray = try context.fetch(request)
        } catch {
            print("Error reload data")
        }
    }
    
    private func selectRowAtZero() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath as IndexPath)
    }
    
    @objc func loadData(){
        loadItem()
        self.tableView.reloadData()
        let indexPath = NSIndexPath(row: productArray.count - 1, section: 0)
        tableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath as IndexPath)
    }
    
    @objc func loadUpdateData(){
        loadItem()
        tableView.reloadData()
        tableView.selectRow(at: index as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: index as IndexPath)
    }
    
    private func addCommaNumber(string: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSize = 3
        let formattedNumber = numberFormatter.string(from: NSNumber(value:Double(string)!))
        return formattedNumber!
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive && searchController.searchBar.text != "") {
            return filterProduct.count
        }
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ProductTableViewCell", owner: self, options: nil)?.first as! ProductTableViewCell
        if(searchController.isActive && searchController.searchBar.text != "") {
            cell.titleLabel.text = filterProduct[indexPath.row].productName
            cell.detailLabel.text = filterProduct[indexPath.row].peopleType
            cell.rightLabel.text = addCommaNumber(string: String(filterProduct[indexPath.row].money))
        } else {
            cell.titleLabel.text = productArray[indexPath.row].productName
            cell.detailLabel.text = productArray[indexPath.row].peopleType
            cell.rightLabel.text = addCommaNumber(string: String(productArray[indexPath.row].money))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(searchController.isActive && searchController.searchBar.text != "") {
                var empId = ""
                empId = (filterProduct[indexPath.row].id)!
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Product")
                let predicate = NSPredicate(format: "id = '\(empId)'")
                fetchRequest.predicate = predicate
                let objects = try! context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object as! NSManagedObject)
                }
                saveItem()
                self.filterProduct.remove(at: indexPath.row)
                self.productArray.remove(at: indexPath.row + 1)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                if(productArray.count > 0) {
                    selectRowAtZero()
                }
            } else {
                var empId = ""
                empId = (productArray[indexPath.row].id)!
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Product")
                let predicate = NSPredicate(format: "id = '\(empId)'")
                fetchRequest.predicate = predicate
                let objects = try! context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object as! NSManagedObject)
                }
                saveItem()
                self.productArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                if(productArray.count > 0) {
                    selectRowAtZero()
                }
            }
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailProduct", sender: indexPath)
        index = indexPath as NSIndexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailProduct") {
            let row =  (sender as! NSIndexPath).row
            if(searchController.isActive && searchController.searchBar.text != "") {
                if let destinationVC = segue.destination as? DetailProductViewController {
                    destinationVC.id = filterProduct[row].id
                    destinationVC.productName = filterProduct[row].productName
                    destinationVC.money = String(filterProduct[row].money)
                    destinationVC.people = filterProduct[row].peopleType
                    destinationVC.unit = String(filterProduct[row].unit)
                    destinationVC.weight = String(filterProduct[row].weight)
                    destinationVC.date = filterProduct[row].date
                }
            } else {
                if let destinationVC = segue.destination as? DetailProductViewController {
                    if row > -1 {
                        destinationVC.id = productArray[row].id
                        destinationVC.productName = productArray[row].productName
                        destinationVC.money = String(productArray[row].money)
                        destinationVC.people = productArray[row].peopleType
                        destinationVC.unit = String(productArray[row].unit)
                        destinationVC.weight = String(productArray[row].weight)
                        destinationVC.date = productArray[row].date
                    }
                }
            }
        } else if(segue.identifier == "showAddNewProduct") {
            _ = segue.destination as? AddNewViewController
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print(selectedScope)
    }
}










