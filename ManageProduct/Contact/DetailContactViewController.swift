//
//  DetailContactViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/4/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import CoreData

class DetailContactViewController: UIViewController {
    
    @IBOutlet var txtName: UILabel!
    @IBOutlet var txtPhone: FloatingTextField!
    @IBOutlet var txtType: UILabel!
    @IBOutlet var txtCard: FloatingTextField!
    @IBOutlet var txtCardDate: FloatingTextField!
    @IBOutlet var txtBankCode: FloatingTextField!
    @IBOutlet var txtBankLocation: FloatingTextField!
    @IBOutlet var txtProduct: FloatingTextField!
    @IBOutlet var btnEditText: UIButton!
    
    var id, name, phone, card, cardDate, bankCode, bankLocation, type, product:String?
    
    @IBAction func btnEdit(_ sender: Any) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtName.text = name
        txtPhone.text = phone
        txtCard.text = card
        txtCardDate.text = cardDate
        txtBankCode.text = bankCode
        txtBankLocation.text = bankLocation
        txtType.text = type
        txtProduct.text = product
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(txtPhone.text != "") {
            let updateVC = segue.destination as! UpdateTableViewController            
            updateVC.id = id!
            updateVC.name = self.txtName.text!
            updateVC.phone = self.txtPhone.text!
            updateVC.card = self.txtCard.text!
            updateVC.cardDate = self.txtCardDate.text!
            updateVC.bankCode = self.txtBankCode.text!
            updateVC.bankLocation = self.txtBankLocation.text!
            updateVC.productText = self.txtProduct.text!
            updateVC.typeText = self.txtType.text!
        }
        
    }
    
}









