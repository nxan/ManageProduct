//
//  CheckTypeTableViewController.swift
//  ManageProduct
//
//  Created by NXA on 2/3/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class CheckTypeTableViewController: UITableViewController {
    
    let types = ["Nhập Hàng", "Bán Hàng"]
    var selectIndex = 0
    var selectType = "Nhập Hàng"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            let userDefaultStore = UserDefaults.standard
            userDefaultStore.set(selectType, forKey: "key_Type")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.string(forKey: "peopleTypeFromParent")) != nil {
            selectType = UserDefaults.standard.string(forKey: "peopleTypeFromParent")!
        }
        selectIndex = (selectType == "Nhập Hàng") ? 0 : 1
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = types[indexPath.row]
        if(indexPath.row == selectIndex) {
            cell.accessoryType = .checkmark;
        }
        else {
            cell.accessoryType = .none;
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectType = types[indexPath.row]
        selectIndex = indexPath.row;
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Thể loại"
    }
}
