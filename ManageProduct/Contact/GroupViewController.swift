//
//  GroupViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/8/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    var list = ["Tất cả", "Người Nhập Hàng", "Khách Hàng"]
    var selectIndex = 0
    var selectType = "Tất cả"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDone(_ sender: Any) {
        let userDefaultStore = UserDefaults.standard
        userDefaultStore.set(selectType, forKey: "key_Value")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadType"), object: nil)
        dismiss(animated: true, completion: nil)
    }

}

extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
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











