//
//  GroupViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/8/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}


