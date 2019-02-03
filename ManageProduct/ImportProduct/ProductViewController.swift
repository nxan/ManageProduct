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
    var productSortArray: [Date:[Product]?] = [:]
    var filterSortProduct: [Date:[Product]?] = [:]
    let searchController = UISearchController(searchResultsController: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var index = NSIndexPath()
    var x = [String]()
    var dateArray: [Date] = []
    var filterDateArray: [Date] = []
    var flag = false
    var updateView = UpdateProductViewController()
    var selectScope = "Tất cả"
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func refreshProduct(_ sender: Any) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        loadItem()
        if(productArray.count > 0) {
            selectRowAtZero()
            NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadData"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(loadUpdateData), name: NSNotification.Name(rawValue: "loadUpdateData"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(filterByDate), name: NSNotification.Name(rawValue: "loadByDate"), object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
//        navigationController?.setToolbarHidden(false, animated: false)
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
    
    @objc func filterByDate() {
        productArray.removeAll()
        loadDataByDate(beginDate: UserDefaults.standard.string(forKey: "BeginDate")!, endDate: UserDefaults.standard.string(forKey: "EndDate")!)
        self.tableView.reloadData()
        let indexPath = NSIndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath as IndexPath)
        
    }
    
    private func filterContent(searchText: String) {
        if(searchText.isEmpty || searchText == "") {
            loadDataByType(type: selectScope)
            flag = true
            filterProduct = productArray.filter { product in
                if(searchText == "") {
                    return true
                }
                return (product.productName?.contains(searchText))! || (product.peopleType?.contains(searchText))!
            }
        } else {
            
            filterProduct = filterProduct.filter { product in
                if(searchText == "") {
                    return true
                }
                return (product.productName?.contains(searchText))! || (product.peopleType?.contains(searchText))!
            }
        }
    }
    
    private func loadItem() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            productArray = try context.fetch(request)
        } catch {
            print("Error reload data")
        }
        order(array: productArray)
        dateArray = Array(productSortArray.keys)
        dateArray.sort { $0 > $1 }
    }
    
    private func loadItemFilter() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            filterProduct = try context.fetch(request)
        } catch {
            print("Error reload data")
        }
        orderFilter(array: filterProduct)
        filterDateArray = Array(filterSortProduct.keys)
        filterDateArray.sort { $0 > $1 }
    }

    
    private func selectRowAtZero() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath as IndexPath)
    }
    
    @objc func loadData() {
        if(selectScope == "Nhập Hàng" || selectScope == "Bán Hàng") {
            loadDataByType(type: selectScope)
            flag = true
            self.tableView.reloadData()
            selectRowAtZero()
        } else {
            loadItem()
            self.tableView.reloadData()
            selectRowAtZero()
        }
        
    }
    
    @objc func loadUpdateData() {
        loadItem()
        //self.productSortArray[dateArray[index.section]]!!.remove(at: index.row)
        loadDataByType(type: selectScope)
        flag = true
        self.tableView.reloadData()
    }
    
    public func loadDataByDate(beginDate: String, endDate: String) {
        productArray.removeAll()
        dateArray.removeAll()
        productSortArray.removeAll()
        let fromdate = "\(beginDate) 00:00"
        let todate = "\(endDate) 23:59"
        do {
            let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.returnsObjectsAsFaults = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let a:Date = dateFormatter.date(from: fromdate)!
            let b:Date = dateFormatter.date(from: todate)!
            fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", a as CVarArg, b as CVarArg)
            let fetchedResults = try context.fetch(fetchRequest)
            for result in fetchedResults {
                productArray.append(result)
            }
        } catch {
            print("Error")
        }
        order(array: productArray)
        dateArray = Array(productSortArray.keys)
        dateArray.sort { $0 > $1 }
    }
    
    public func loadDataByType(type: String) {
        if(searchController.isActive && searchController.searchBar.text != "") {
            filterProduct.removeAll()
            filterDateArray.removeAll()
            filterSortProduct.removeAll()
            if(type == "Tất cả") {
                loadItemFilter()
            } else {
                do {
                    let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "type == %@", type)
                    let fetchedResults = try context.fetch(fetchRequest)
                    for result in fetchedResults {
                        filterProduct.append(result)
                    }
                } catch {
                    print("Error")
                }
            }
            orderFilter(array: filterProduct)
            filterDateArray = Array(filterSortProduct.keys)
            filterDateArray.sort { $0 > $1 }
            updateSearchResults(for: searchController)
        } else {
            productArray.removeAll()
            dateArray.removeAll()
            productSortArray.removeAll()
            if(type == "Tất cả") {
                loadItem()
            } else {
                do {
                    let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "type == %@", type)
                    let fetchedResults = try context.fetch(fetchRequest)
                    for result in fetchedResults {
                        productArray.append(result)
                    }
                } catch {
                    print("Error")
                }
            }
            order(array: productArray)
            dateArray = Array(productSortArray.keys)
            dateArray.sort { $0 > $1 }
        }
    }
    
    
    private func order(array: [Product]) {
        for product in array {
            var products = productSortArray[product.date!] ?? []
            if products?.count == 0 {
                productSortArray[product.date!] = [product]
            } else {
                if(!(products?.contains(product))!) {
                    products?.insert(product, at: 0)
                }
                productSortArray[product.date!] = products
            }
        }
    }
    
    private func orderFilter(array: [Product]) {
        filterDateArray.removeAll()
        filterSortProduct.removeAll()
        for product in filterProduct {
            var products = filterSortProduct[product.date!] ?? []
            if products?.count == 0 {
                filterSortProduct[product.date!] = [product]
            } else {
                if(!(products?.contains(product))!) {
                    products?.insert(product, at: 0)
                }
                filterSortProduct[product.date!] = products
            }
        }
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(searchController.isActive && searchController.searchBar.text != "") {
            return filterDateArray.count
        }
        return dateArray.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if(searchController.isActive && searchController.searchBar.text != "") {
//            return MyDateTime.convertDateToString(date: filterDateArray[section])
//        }
//        return MyDateTime.convertDateToString(date: dateArray[section])
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("TableSectionHeader", owner: self, options: nil)?.first as! TableSectionHeader
        if(searchController.isActive && searchController.searchBar.text != "") {
            var money: Double = 0
            for i in 0..<filterSortProduct[filterDateArray[section]]!!.count {

                money += filterSortProduct[filterDateArray[section]]!![i].money
            }
            header.lblTotal.text = MyDateTime.addCommaNumber(string: String(money))
            header.txtDate.text = MyDateTime.convertDateToString(date: dateArray[section])
        } else {
            var money: Double = 0
            for i in 0..<productSortArray[dateArray[section]]!!.count {

                money += productSortArray[dateArray[section]]!![i].money
            }
            header.lblTotal.text = MyDateTime.addCommaNumber(string: String(money))
            header.txtDate.text = MyDateTime.convertDateToString(date: dateArray[section])
        }
        if(selectScope == "Tất cả") {
            header.lblTotal.isHidden = true
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive && searchController.searchBar.text != "") {
            return (filterSortProduct[filterDateArray[section]]!!.count)
        }
        return (productSortArray[dateArray[section]]!!.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ProductTableViewCell", owner: self, options: nil)?.first as! ProductTableViewCell
        if(searchController.isActive && searchController.searchBar.text != "") {
            let filterProduct = filterSortProduct[filterDateArray[indexPath.section]]!![indexPath.row]
            cell.titleLabel.text = filterProduct.productName
            cell.detailLabel.text = filterProduct.peopleType
            cell.rightLabel.text = MyDateTime.addCommaNumber(string: String(filterProduct.money))
            if(filterProduct.type == "Nhập Hàng") {
                cell.rightLabel.textColor = UIColor.red
            } else {
                cell.rightLabel.textColor = UIColor(red: 24/255, green: 160/255, blue: 42/255, alpha: 1)
            }
        } else {
            let product = productSortArray[dateArray[indexPath.section]]!![indexPath.row]
            cell.titleLabel.text = product.productName
            cell.detailLabel.text = product.peopleType
            cell.rightLabel.text = MyDateTime.addCommaNumber(string: String(product.money))
            if(product.type == "Nhập Hàng") {
                cell.rightLabel.textColor = UIColor.red
            } else {
                cell.rightLabel.textColor = UIColor(red: 24/255, green: 160/255, blue: 42/255, alpha: 1)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(searchController.isActive && searchController.searchBar.text != "") {
                let filterProduct = filterSortProduct[filterDateArray[indexPath.section]]!![indexPath.row]
                MyCoreData.removeItem(id: filterProduct.id!)
                MyCoreData.saveItem()
                self.filterProduct.remove(at: indexPath.row)
                self.filterSortProduct[filterDateArray[indexPath.section]]!!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if(filterSortProduct[filterDateArray[indexPath.section]]!!.isEmpty) {
                    filterSortProduct.removeValue(forKey: filterDateArray[indexPath.section])
                    while filterDateArray.contains(filterDateArray[indexPath.section]) {
                        if let itemToRemoveIndex = filterDateArray.index(of: filterDateArray[indexPath.section]) {
                            filterDateArray.remove(at: itemToRemoveIndex)
                            break
                        }
                    }
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    tableView.deleteSections(indexSet, with: .fade)
                }
                tableView.reloadData()
            } else {
                let product = productSortArray[dateArray[indexPath.section]]!![indexPath.row]
                MyCoreData.removeItem(id: product.id!)
                MyCoreData.saveItem()
                self.productArray.remove(at: indexPath.row)
                self.productSortArray[dateArray[indexPath.section]]!!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if(productSortArray[dateArray[indexPath.section]]!!.isEmpty) {
                    productSortArray.removeValue(forKey: dateArray[indexPath.section])
                    while dateArray.contains(dateArray[indexPath.section]) {
                        if let itemToRemoveIndex = dateArray.index(of: dateArray[indexPath.section]) {
                            dateArray.remove(at: itemToRemoveIndex)
                            break
                        }
                    }
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    tableView.deleteSections(indexSet, with: .fade)
                }
                tableView.reloadData()
                selectRowAtZero()
            }
        } else if editingStyle == .insert {

        }
    }      

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailProduct", sender: indexPath)
        index = indexPath as NSIndexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailProduct") {
            let section = (sender as! IndexPath).section
            let row =  (sender as! IndexPath).row
            if(searchController.isActive && searchController.searchBar.text != "") {
                let filterProduct = filterSortProduct[filterDateArray[section]]!![row]
                if let destinationVC = segue.destination as? DetailProductViewController {
                    destinationVC.id = filterProduct.id
                    destinationVC.productName = filterProduct.productName
                    destinationVC.money = String(filterProduct.money)
                    destinationVC.people = filterProduct.peopleType
                    destinationVC.unit = String(filterProduct.unit)
                    destinationVC.weight = String(filterProduct.weight)
                    destinationVC.date = MyDateTime.convertDateToString(date: filterProduct.date!)
                    destinationVC.note = filterProduct.note
                    destinationVC.transaction = filterProduct.type
                }
            } else {
                if(productArray.count == 0) {
                    return
                }
                let product = productSortArray[dateArray[section]]!![row]
                if let destinationVC = segue.destination as? DetailProductViewController {
                    if row > -1 {
                        destinationVC.id = product.id
                        destinationVC.productName = product.productName
                        destinationVC.money = String(product.money)
                        destinationVC.people = product.peopleType
                        destinationVC.unit = String(product.unit)
                        destinationVC.weight = String(product.weight)
                        destinationVC.date = MyDateTime.convertDateToString(date: product.date!)
                        destinationVC.note = product.note
                        destinationVC.transaction = product.type
                    }
                }
            }
        } else if(segue.identifier == "showAddNewProduct") {
            _ = segue.destination as? AddNewTableViewController
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if(flag) { filterProduct = productArray }
        flag = false
        filterContent(searchText: searchController.searchBar.text!)
        orderFilter(array: filterProduct)
        filterDateArray = Array(filterSortProduct.keys)
        filterDateArray.sort { $0 > $1 }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 1:
            loadDataByType(type: "Nhập Hàng")
            selectScope = "Nhập Hàng"
            break
        case 2:            
            loadDataByType(type: "Bán Hàng")
            selectScope = "Bán Hàng"
            break
        default:
            loadDataByType(type: "Tất cả")
            selectScope = "Tất cả"
            break
        }
        tableView.reloadData()
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}









