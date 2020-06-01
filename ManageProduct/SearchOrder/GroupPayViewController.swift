//
//  GroupPayViewController.swift
//  ManageProduct
//
//  Created by NXA on 2/25/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class GroupPayViewController: UIViewController {
    
    var list = ["Chưa thanh toán", "Đã thanh toán", "Tất cả"]
    var selectIndex = 0
    var selectType = "Chưa thanh toán"
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func btnDone(_ sender: Any) {
        let userDefaultStore = UserDefaults.standard
        userDefaultStore.set(selectType, forKey: "typePay")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadType"), object: nil)
        dismiss(animated: true, completion: nil)
        print(selectType)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectType = UserDefaults.standard.string(forKey: "typePay")!
        if selectType == "Chưa thanh toán" {
            selectIndex = 0
        } else if selectType == "Đã thanh toán" {
            selectIndex = 1
        } else {
            selectIndex = 2
        }
    }
    
}

extension GroupPayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = list[indexPath.row]
        if(indexPath.row == selectIndex) {
            cell.accessoryType = .checkmark;
        }
        else {
            cell.accessoryType = .none;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectType = list[indexPath.row]
        selectIndex = indexPath.row;
        tableView.reloadData()
    }
    
}
