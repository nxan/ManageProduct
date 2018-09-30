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
        performSegue(withIdentifier: "showDetailProduct", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(id != nil) {
            txtProductName.text = productName
            txtMoney.text = addCommaNumber(string: money!) + " VND"
            txtPeople.text = people
            txtUnit.text = addCommaNumber(string: unit!) + " VND"
            txtWeight.text = addCommaNumber(string: weight!) + " Kg"
            txtDate.text = date
            txtNote.text = note
            if(transaction == "Nhập Hàng") {
                txtMoney.textColor = UIColor.red
            } else {
                txtMoney.textColor = UIColor(red: 24/255, green: 160/255, blue: 42/255, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }        
    
    private func addCommaNumber(string: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSize = 3
        let formattedNumber = numberFormatter.string(from: NSNumber(value:Double(string)!))
        return formattedNumber!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(txtProductName.text != "") {
            let updateVC = segue.destination as! UpdateProductViewController
            updateVC.id = id!
            updateVC.productName = self.productName!
            updateVC.people = self.people!
            updateVC.money = self.addCommaNumber(string: money!)
            updateVC.unit = self.addCommaNumber(string: unit!)
            updateVC.weight = self.addCommaNumber(string: weight!)
            updateVC.date = self.date!
            updateVC.note = self.note!
            updateVC.transaction = self.transaction!
        }
    }
}
