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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var txtName: UILabel!
    @IBOutlet var txtPhone: FloatingTextField!
    @IBOutlet var txtType: UILabel!
    @IBOutlet var txtCard: FloatingTextField!
    @IBOutlet var txtCardDate: FloatingTextField!
    @IBOutlet var txtBankCode: FloatingTextField!
    @IBOutlet var txtBankLocation: FloatingTextField!
    @IBOutlet var txtProduct: FloatingTextField!
    @IBOutlet var btnEditText: UIButton!
    
    var productTextField: UITextField!
    var productArray = [Product]()
    
    var id, name, phone, card, cardDate, bankCode, bankLocation, type, product:String?
    
    @IBAction func btnEdit(_ sender: Any) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
//    @IBAction func displayAlertAddNewProduct(_ sender: Any) {
//        let alertController = UIAlertController(title: "Thêm sản phẩm", message: nil, preferredStyle: .alert)
//        alertController.addTextField(configurationHandler: productTextField)
//
//        let okAction = UIAlertAction(title: "Thêm", style: .default, handler: self.okHandler)
//        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true)
//    }
//
//    func productTextField(textField: UITextField!) {
//        productTextField = textField
//        productTextField.placeholder = "Ví dụ: Củ sen, Củ năng..."
//        productTextField.autocapitalizationType = .sentences
//    }
//
//    func okHandler(alert: UIAlertAction) {
//        let newItem = Product(context: self.context)
//        newItem.name = productTextField.text
//        self.productArray.append(newItem)
//        self.saveItem()
//    }
    
    private func saveItem() {
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Error save")
        }
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
        if(txtName.text != "") {
            if(segue.identifier == "showDetail") {
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
    
}









