//
//  AddNewTableViewController.swift
//  ManageProduct
//
//  Created by NXA on 12/13/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

protocol AddNewToDelegate {
    func addNewPeople(people: People)
    func updatePeoPle(people: People)
}

class AddNewTableViewController: UITableViewController {
    
    var delegate: AddNewToDelegate?
    let type = ["", "Người Nhập Hàng", "Khách Hàng"]
    var product = [""]
    var selectItem: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var peopleArray = [People]()
    var productArray = [Product]()
    var typeCheck = UserDefaults.standard.string(forKey: "type")
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtCard: UITextField!
    @IBOutlet var txtCardDate: UITextField!
    @IBOutlet var txtBankCode: UITextField!
    @IBOutlet var txtBankLocation: UITextField!
    @IBOutlet var txtProduct: UITextField!
    @IBOutlet var txtType: UITextField!
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
        if(typeCheck != "Tất cả") {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadType"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func txtNameChanged(_ sender: Any) {
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
        product = getProductName()
        txtName.autocapitalizationType = .words
    }
    
    private func getProductName() -> [String] {
        var arrProduct = [String]()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Product", in: context)
        let fetchRequest = NSFetchRequest<NSDictionary>()
        fetchRequest.entity = entityDescription
        fetchRequest.includesPropertyValues = true
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = ["name"]
        fetchRequest.resultType = .dictionaryResultType
        do {
            let productList = try context.fetch(fetchRequest)
            let resultDict = productList as! [[String : String]]
            for r in resultDict {
                arrProduct.append(r["name"]!)
            }
            arrProduct.insert("", at: 0)
        } catch let error as NSError {
            print(error)
        }
        
        return arrProduct
    }
    
    private func saveItem() {
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Error save")
        }
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
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(AddNewTableViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtType.inputAccessoryView = toolbar
        txtProduct.inputAccessoryView = toolbar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddNewTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
