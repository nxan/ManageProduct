//
//  UpdateViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/5/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class UpdateViewController: UIViewController {
    
    let type = ["", "Người nhập hàng", "Khách hàng"]
    let product = ["", "Củ sen", "Củ hành"]
    var selectItem: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var peopleArray = [People]()
    var id = "", name = "", phone = "", card = "", cardDate = "", bankCode = "", bankLocation = "", productText = "", typeText = ""
    
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
        let empId = id
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "People")
        let predicate = NSPredicate(format: "id = '\(empId)'")
        fetchRequest.predicate = predicate
        do
        {
            let test = try context.fetch(fetchRequest)
            if test.count == 1
            {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(txtName.text, forKey: "name")
                objectUpdate.setValue(txtPhone.text, forKey: "phone")
                objectUpdate.setValue(txtCard.text, forKey: "card")
                objectUpdate.setValue(txtCardDate.text, forKey: "cardDate")
                objectUpdate.setValue(txtBankCode.text, forKey: "bankCode")
                objectUpdate.setValue(txtBankLocation.text, forKey: "bankLocation")
                objectUpdate.setValue(txtProduct.text, forKey: "product")
                objectUpdate.setValue(txtType.text, forKey: "type")
                saveItem()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
                dismiss(animated: true, completion: nil)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerViewType()
        createPickerViewProduct()
        createToolbarPickerView()
        btnSaveText.isEnabled = true
        updateItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(UpdateViewController.dismissKeyboard))
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
    
    private func updateItem() {
        txtName.text = name
        txtPhone.text = phone
        txtCard.text = card
        txtCardDate.text = cardDate
        txtBankLocation.text = bankLocation
        txtBankCode.text = bankCode
        txtType.text = typeText
        txtProduct.text = productText
    }
    
}

extension UpdateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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









