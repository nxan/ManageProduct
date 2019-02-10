//
//  DetailProductViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/20/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit

class DetailProductViewController: UIViewController {
    
    @IBOutlet var txtProductName: UILabel!
    @IBOutlet var txtMoney: UILabel!
    @IBOutlet var txtPeople: FloatingTextField!
    @IBOutlet var txtUnit: FloatingTextField!
    @IBOutlet var txtWeight: FloatingTextField!
    @IBOutlet var txtDate: UILabel!
    @IBOutlet var txtNote: FloatingTextField!
    
    var id, productName, money, people, unit, weight, date, note, transaction: String?
    
    @IBAction func btnEdit(_ sender: Any) {
        let userDefaultStore = UserDefaults.standard
        userDefaultStore.set(txtPeople.placeholder, forKey: "key_type")
        performSegue(withIdentifier: "showDetailProduct", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(id != nil) {
            txtProductName.text = productName
            txtMoney.text = MyDateTime.addCommaNumber(string: money!)! + " VND"
            txtPeople.text = people
            txtUnit.text = MyDateTime.addCommaNumber(string: unit!)! + " VND"
            txtWeight.text = MyDateTime.addCommaNumber(string: weight!)! + " Kg"
            txtDate.text = date
            txtNote.text = note
            if(transaction == "Nhập Hàng") {
                txtMoney.textColor = UIColor.red
                txtPeople.placeholder = "Người nhập hàng"
            } else {
                txtMoney.textColor = UIColor(red: 24/255, green: 160/255, blue: 42/255, alpha: 1)
                txtPeople.placeholder = "Khách hàng"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(txtProductName.text != "") {
            let updateVC = segue.destination as! UpdateProductViewController
            updateVC.id = id!
            updateVC.productName = self.productName!
            updateVC.people = self.people!
            updateVC.money = MyDateTime.addCommaNumber(string: money!)!
            updateVC.unit = MyDateTime.addCommaNumber(string: unit!)!
            updateVC.weight = MyDateTime.addCommaNumber(string: weight!)!
            updateVC.date = self.date!
            updateVC.note = self.note!
            updateVC.transaction = self.transaction!
        }
    }
}


