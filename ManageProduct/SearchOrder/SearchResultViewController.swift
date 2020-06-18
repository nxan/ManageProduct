//
//  SearchResultViewController.swift
//  ManageProduct
//
//  Created by NXA on 2/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import CoreData

class SearchResultViewController: UIViewController {
    
    var searchArray = [Transaction]()
    var searchCustomer = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var name = "", beginDate = "", endDate = ""
    var totalMoney = 0
    var tempPay: Int = 0
    let typeUserDefault = UserDefaults.standard
    var typeCheck = "Tất cả"
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblTotalMoney: UILabel!
    @IBOutlet var lblType: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadType"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadOrderByDate"), object: nil)
        typeUserDefault.set(typeCheck, forKey: "typePay")
        typeUserDefault.set(MyDateTime.getCurrentDate(), forKey: "BeginOrderDate")
        typeUserDefault.set(MyDateTime.getCurrentDate(), forKey: "EndOrderDate")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataByType(name: searchCustomer, isPay: UserDefaults.standard.string(forKey: "typePay")!, beginDate: UserDefaults.standard.string(forKey: "BeginOrderDate") ?? "", endDate: UserDefaults.standard.string(forKey: "EndOrderDate") ?? "")
        self.tableView.reloadData()
    }
    
    
    
    @objc func loadList() {
        searchArray.removeAll()
        loadDataByType(name: searchCustomer, isPay: UserDefaults.standard.string(forKey: "typePay")!, beginDate: UserDefaults.standard.string(forKey: "BeginOrderDate") ?? "", endDate: UserDefaults.standard.string(forKey: "EndOrderDate") ?? "")
        self.tableView.reloadData()
    }
    
    @objc func filterOrderByDate() {
        loadDataByDate(name: searchCustomer, beginDate: UserDefaults.standard.string(forKey: "BeginOrderDate") ?? "", endDate: UserDefaults.standard.string(forKey: "EndOrderDate") ?? "")
        self.tableView.reloadData()
    }
    
    private func loadDataByDate(name: String, beginDate: String, endDate: String) {
        searchArray.removeAll()
        let fromdate = "\(beginDate) 00:00"
        let todate = "\(endDate) 23:59"
        do {
            let fetchRequest : NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchRequest.returnsObjectsAsFaults = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let a:Date = dateFormatter.date(from: fromdate)!
            let b:Date = dateFormatter.date(from: todate)!
            fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) && peopleType == %@ && isPay = '\(tempPay)'", a as CVarArg, b as CVarArg, name)
            let fetchedResults = try context.fetch(fetchRequest)
            for result in fetchedResults {
                searchArray.append(result)
            }
        } catch {
            print("Error")
        }
//        order(array: productArray)
//        dateArray = Array(productSortArray.keys)
//        dateArray.sort { $0 > $1 }
    }
    
    private func loadDataByType(name: String, isPay: String, beginDate: String, endDate: String) {
        let fromdate = "\(beginDate) 00:00"
        let todate = "\(endDate) 23:59"
        switch isPay {
        case "Chưa thanh toán":
            tempPay = 0
            lblType.text = "Danh sách đơn hàng chưa thanh toán"
        case "Đã thanh toán":
            tempPay = 1
            lblType.text = "Danh sách đơn hàng đã thanh toán"
        default:
            tempPay = 2
            lblType.text = "Danh sách đầy đủ"
        }
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let a:Date = dateFormatter.date(from: fromdate)!
        let b:Date = dateFormatter.date(from: todate)!
        if(tempPay == 0 || tempPay == 1) {
            request.predicate = NSPredicate(format: "peopleType == %@ && isPay = '\(tempPay)' && (date >= %@) AND (date <= %@)", name, a as CVarArg, b as CVarArg)
        } else {
            request.predicate = NSPredicate(format: "peopleType == %@ && (date >= %@) AND (date <= %@)", name, a as CVarArg, b as CVarArg)
        }
        let sort = NSSortDescriptor(key: #keyPath(Transaction.date), ascending: false)
        request.sortDescriptors = [sort]
        do {
            searchArray = try context.fetch(request)
        } catch {
            print("Error reload data")
        }
    }

    
    private func loadCustomerNotPay(name: String) {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "peopleType == %@ && isPay = '\(false)'", name)
        let sort = NSSortDescriptor(key: #keyPath(Transaction.date), ascending: false)
        request.sortDescriptors = [sort]
        do {
            searchArray = try context.fetch(request)
        } catch {
            print("Error reload data")
        }
    }
    
    private func loadCustomerPay(name: String) {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "peopleType == %@ && isPay = '\(1)'", name)
        let sort = NSSortDescriptor(key: #keyPath(Transaction.date), ascending: false)
        request.sortDescriptors = [sort]
        do {
            searchArray = try context.fetch(request)
        } catch {
            print("Error reload data")
        }
    }
    
    private func updateToPay(id: String) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Transaction")
        let predicate = NSPredicate(format: "id = '\(id)'")
        fetchRequest.predicate = predicate
        do {
            let test = try context.fetch(fetchRequest)
            if test.count == 1 {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(true, forKey: "isPay")
                MyCoreData.saveItem()
            }
        }
        catch {
            print(error)
        }
    }
    
    private func updateNotToPay(id: String) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Transaction")
        let predicate = NSPredicate(format: "id = '\(id)'")
        fetchRequest.predicate = predicate
        do {
            let test = try context.fetch(fetchRequest)
            if test.count == 1 {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(false, forKey: "isPay")
                MyCoreData.saveItem()
            }
        }
        catch {
            print(error)
        }
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("SearchTableSectionHeader", owner: self, options: nil)?.first as! SearchTableSectionHeader
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchResultTableViewCell", owner: self, options: nil)?.first as! SearchResultTableViewCell
        let result = searchArray[indexPath.row]
        cell.textDateLabel.text = MyDateTime.convertDateToString(date: result.date!)
        cell.textProductLabel.text = result.productName
        cell.textUnitLabel.text = MyDateTime.addCommaNumber(string: String(result.unit))
        cell.textWeightLabel.text = MyDateTime.addCommaNumber(string: String(result.weight))
        cell.textMoneyLabel.text = MyDateTime.addCommaNumber(string: String(result.money))
        if(result.isPay && (tempPay == 2 || tempPay == 0)) {
//            cell.backgroundColor = UIColor.lightGray
//            cell.textMoneyLabel.text = "Đã thanh toán"
            cell.imgSuccess.image = UIImage(named: "success")
        }
        lblName.text = "Họ và tên: " + result.peopleType!
        var money: Double = 0
        for i in 0..<searchArray.count {
            money += searchArray[i].money
        }
        lblTotalMoney.text = "Tổng cộng: " + MyDateTime.addCommaNumber(string: String(money))! + "VNĐ"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let payAction = UITableViewRowAction(style: .normal, title: "Đã thanh toán") { (rowAction, indexPath) in
            self.updateToPay(id: (self.searchArray[indexPath.row].id)!)
            if(self.tempPay == 2) {
                self.loadList()
            } else {
                self.loadCustomerNotPay(name: self.searchCustomer)
            }
            tableView.reloadData()
        }
        
        let notPayAction = UITableViewRowAction(style: .normal, title: "Hồi phục thanh toán") { (rowAction, indexPath) in
            self.updateNotToPay(id: (self.searchArray[indexPath.row].id)!)
            if(self.tempPay == 2) {
                self.loadList()
            } else {
                self.loadCustomerPay(name: self.searchCustomer)
            }
            tableView.reloadData()
        }
        
        payAction.backgroundColor = .blue
        notPayAction.backgroundColor = .red
        if(searchArray[indexPath.row].isPay) {
            return [notPayAction]
        } else {
            return [payAction]
        }
    }
}
