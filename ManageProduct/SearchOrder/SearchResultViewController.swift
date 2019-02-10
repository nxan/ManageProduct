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
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblTotalMoney: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCustomer(name: searchCustomer)
    }

    
    private func loadCustomer(name: String) {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "peopleType == %@", name)
        do {
            searchArray = try context.fetch(request)
        } catch {
            print("Error reload data")
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
        lblName.text = "Họ và tên: " + result.peopleType!
        var money: Double = 0
        for i in 0..<searchArray.count {
            money += searchArray[i].money
        }
        lblTotalMoney.text = "Tổng cộng: " + MyDateTime.addCommaNumber(string: String(money))! + "VNĐ"
        return cell
    }
    
    
}
