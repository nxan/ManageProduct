//
//  AddNewViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/1/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

protocol AddNewToDelegate {
    func addNewPeople(people: People)
    func updatePeoPle(people: People)
}

class AddNewViewController: UIViewController {
    
    
    var delegate: AddNewToDelegate?
    let type = ["", "Người nhập hàng", "Khách hàng"]
    let product = ["", "Củ sen", "Củ hành"]
    var selectItem: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var peopleArray = [People]()
    
    @IBOutlet var txtName: FloatingTextField!
    @IBOutlet var txtPhone: FloatingTextField!
    @IBOutlet var txtCard: FloatingTextField!
    @IBOutlet var txtCardDate: FloatingTextField!
    @IBOutlet var txtBankCode: FloatingTextField!
    @IBOutlet var txtBankLocation: FloatingTextField!
    @IBOutlet var txtProduct: FloatingTextField!
    @IBOutlet var txtType: FloatingTextField!
    @IBOutlet var btnSaveText: UIBarButtonItem!
    @IBAction func btnSave(_ sender: Any) {
        let newItem = People(context: self.context)
        newItem.id = UUID.init().uuidString
        newItem.name = txtName.text
        newItem.phone = txtPhone.text
        newItem.card = txtCard.text
        newItem.cardDate = txtCardDate.text
        newItem.bankCode = txtBankCode.text
        newItem.bankLocation = txtBankLocation.text
        newItem.type = txtType.text
        newItem.product = txtProduct.text
        self.peopleArray.append(newItem)
        self.saveItem()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func txtNameDidChanged(_ sender: Any) {
        btnSaveText.isEnabled = true
        if(txtName.text == "") {
            btnSaveText.isEnabled = false
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerViewType()
        createPickerViewProduct()
        createToolbarPickerView()
        btnSaveText.isEnabled = false
    }
    
    private func createPickerViewType() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
        txtType.inputView = typePicker
    }
    
    private func createPickerViewProduct() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
        txtProduct.inputView = typePicker
    }
    
    private func createToolbarPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(AddNewViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtType.inputAccessoryView = toolbar
        txtProduct.inputAccessoryView = toolbar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func saveItem() {
        do {
        
            try context.save()
            print("Saved")
        } catch {
            print("Error save")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AddNewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var item = 0
        if(txtType.isEditing) {
            item = type.count
        } else if(txtProduct.isEditing) {
            item = product.count
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var item = ""
        if(txtType.isEditing) {
            item = type[row]
        } else if(txtProduct.isEditing) {
            item = product[row]
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(txtType.isEditing) {
            selectItem = type[row]
            txtType.text = selectItem
        } else if(txtProduct.isEditing) {
            selectItem = product[row]
            txtProduct.text = selectItem
        }
    }
}















