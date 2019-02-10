//
//  SearchOrderViewController.swift
//  ManageProduct
//
//  Created by NXA on 2/4/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import CoreData

class SearchOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var product = "", customer = "", importer = "";
    @IBOutlet var tableView: UITableView!
    
    var sections = [Section]()
    var flag = false;
    
    var selectIndexPath: IndexPath!
    
    @IBAction func btnRefresh(_ sender: Any) {
        
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectIndexPath = IndexPath(row: -1, section: -1)
        let nib = UINib(nibName: "ExpandableHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "expandableHeaderView")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectIndexPath = IndexPath(row: -1, section: -1)
        let nib = UINib(nibName: "ExpandableHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "expandableHeaderView")
        
        sections = [
            Section(key: "Khách Hàng", value: getPeople(type: "Khách Hàng"), expanded: false, subtitle: "Vui lòng chọn khách hàng"),
            Section(key: "Người Nhập Hàng", value: getPeople(type: "Người Nhập Hàng"), expanded: false, subtitle: "Vui lòng chọn người nhập hàng")
        ]
        tableView.reloadData()
    }

    private func getPeople(type: String) -> [String] {
        var arrPeople = [String]()
        let tempTypePeople = (type == "Người Nhập Hàng") ? "Nhập Hàng" : "Bán Hàng"
        let entityDescription = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
        let fetchRequest = NSFetchRequest<NSDictionary>()
        fetchRequest.entity = entityDescription
        fetchRequest.includesPropertyValues = true
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "type == %@", tempTypePeople)
        fetchRequest.propertiesToFetch = ["peopleType"]
        fetchRequest.resultType = .dictionaryResultType
        do {
            let personList = try context.fetch(fetchRequest)
            let resultDict = personList as! [[String : String]]
            for r in resultDict {
                if(!arrPeople.contains(r["peopleType"]!)) {
                    arrPeople.append(r["peopleType"]!)
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return arrPeople
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].value.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(sections[indexPath.section].expanded) {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "expandableHeaderView") as! ExpandableHeaderView
        headerView.customInit(title: sections[section].key, subtitle: sections[section].subtitle, section: section, delegate: self)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")
        cell?.textLabel?.text = sections[indexPath.section].value[indexPath.row]
        cell?.accessoryType = (indexPath == selectIndexPath) ? .none : .none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectIndexPath = indexPath
        self.sections[indexPath.section].subtitle = tableView.cellForRow(at: indexPath)?.textLabel?.text
        sections[indexPath.section].expanded = !sections[indexPath.section].expanded
        tableView.beginUpdates()
        tableView.reloadSections([indexPath.section], with: .automatic)
        tableView.endUpdates()
        customer = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        self.performSegue(withIdentifier: "showSearchCustomer", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showSearchCustomer") {
            if let destinationVC = segue.destination as? SearchResultViewController {
                destinationVC.searchCustomer = customer
            }
        }
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        tableView.beginUpdates()
        tableView.reloadSections([section], with: .automatic)
        tableView.endUpdates()
    }
    
}
