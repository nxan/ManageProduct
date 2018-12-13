//
//  MasterViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/27/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit

class MasterViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .allVisible
        self.maximumPrimaryColumnWidth = 600
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


