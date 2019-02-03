//
//  UpdateProductViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/20/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import CoreData

class UpdateProductViewController: UITableViewController {

    var tempProduct = ""
    let type = ["", "Người Nhập Hàng", "Khách Hàng"]
    let product = ["", "Củ Sen", "Củ Hành"]
    var selectItem: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var productArray = [Product]()
    var id = "", productName = "", people = "", money = "", weight = "", unit = "", date = "", note = "", transaction = ""
    let datePicker = UIDatePicker()
    let typePicker = UIPickerView()
    
    @IBOutlet var txtProductName: FloatingTextField!
    @IBOutlet var txtPeople: FloatingTextField!
    @IBOutlet var txtDate: FloatingTextField!
    @IBOutlet var txtWeight: FloatingTextField!
    @IBOutlet var txtMoney: FloatingTextField!
    @IBOutlet var txtUnit: FloatingTextField!
    @IBOutlet var txtNote: FloatingTextField!
    @IBOutlet var lbSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateItem()
        createPickerViewProduct()
        createPickerViewPeople()
        createToolbarPickerView()
        showDatePicker()
        txtMoney.isEnabled = false
        tempProduct = txtProductName.text!
        typePicker.delegate = self
    }
    
    @IBAction func btnSwitch(_ sender: Any) {
        if lbSwitch.isOn {
            createPickerViewProduct()
            createPickerViewPeople()
            createToolbarPickerView()
            txtPeople.isEnabled = true
        } else {
            createPickerViewProduct()
            createPickerViewPeople()
            createToolbarPickerView()
            txtPeople.isEnabled = false            
        }
    }
    
    
    @IBAction func btnEdit(_ sender: Any) {
        let empId = id
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Product")
        let predicate = NSPredicate(format: "id = '\(empId)'")
        fetchRequest.predicate = predicate
        do
        {
            let test = try context.fetch(fetchRequest)
            if test.count == 1
            {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(txtProductName.text, forKey: "productName")
                objectUpdate.setValue(txtPeople.text, forKey: "peopleType")
                objectUpdate.setValue((MyDateTime.removeCommaNumber(string: txtMoney.text!)! as NSString).doubleValue, forKey: "money")
                objectUpdate.setValue((MyDateTime.removeCommaNumber(string: txtWeight.text!)! as NSString).doubleValue, forKey: "weight")
                objectUpdate.setValue((MyDateTime.removeCommaNumber(string: txtUnit.text!)! as NSString).doubleValue, forKey: "unit")
                objectUpdate.setValue(MyDateTime.convertStringToDate(string: txtDate.text!), forKey: "date")
                MyCoreData.saveItem()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUpdateData"), object: nil)
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
    
    @IBAction func txtUnitEditChanged(_ sender: Any) {
        txtUnit.text = MyDateTime.removeCommaNumber(string: txtUnit.text!)
        if(!(txtUnit.text?.isEmpty)!) {
            txtUnit.text = MyDateTime.addCommaNumber(string: txtUnit.text!)
        }
        if(!(txtUnit.text?.isEmpty)! && !(txtWeight.text?.isEmpty)!) {
            txtUnit.text = MyDateTime.removeCommaNumber(string: txtUnit.text!)
            txtWeight.text = MyDateTime.removeCommaNumber(string: txtWeight.text!)
            txtMoney.text = String(Int(txtUnit.text!)! * Int(txtWeight.text!)!)
            txtUnit.text = MyDateTime.addCommaNumber(string: txtUnit.text!)
            txtWeight.text = MyDateTime.addCommaNumber(string: txtWeight.text!)
            txtMoney.text = MyDateTime.addCommaNumber(string: txtMoney.text!)
        } else {
            txtMoney.text = "0"
        }
    }
    
    @IBAction func txtWeightEditChanged(_ sender: Any) {
        txtWeight.text = MyDateTime.removeCommaNumber(string: txtWeight.text!)
        if(!(txtWeight.text?.isEmpty)!) {
            txtWeight.text = MyDateTime.addCommaNumber(string: txtWeight.text!)
        }
        if(!(txtUnit.text?.isEmpty)! && !(txtWeight.text?.isEmpty)!) {
            txtUnit.text = MyDateTime.removeCommaNumber(string: txtUnit.text!)
            txtWeight.text = MyDateTime.removeCommaNumber(string: txtWeight.text!)
            txtMoney.text = String(Double(txtUnit.text!)! * Double(txtWeight.text!)!)
            txtUnit.text = MyDateTime.addCommaNumber(string: txtUnit.text!)
            txtWeight.text = MyDateTime.addCommaNumber(string: txtWeight.text!)
            txtMoney.text = MyDateTime.addCommaNumber(string: txtMoney.text!)
        } else {
            txtMoney.text = "0"
        }
    }
    
    private func updateItem() {
        txtProductName.text = productName
        txtPeople.text = people
        txtMoney.text = money
        txtWeight.text = weight
        txtUnit.text = unit
        txtDate.text = date
        txtNote.text = note
    }
  
    private func createPickerViewProduct() {
        if(lbSwitch.isOn) {
            txtProductName.inputView = nil
        } else {
            txtProductName.inputView = typePicker
        }
    }
    
    private func createPickerViewPeople() {        
        if(lbSwitch.isOn) {
            txtPeople.inputView = nil
        } else {
            txtPeople.inputView = typePicker
        }
    }
    
    private func createToolbarPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(UpdateProductViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        if(lbSwitch.isOn) {
            txtProductName.inputAccessoryView = nil
            txtPeople.inputAccessoryView = nil
        } else {
            txtProductName.inputAccessoryView = toolbar
            txtPeople.inputAccessoryView = toolbar
        }
    }
    
    @objc private func dismissKeyboard() {
        if(!(txtProductName.text?.isEmpty)!) {
            txtPeople.isEnabled = true
        }
        typePicker.selectRow(0, inComponent: 0, animated: false)
        view.endEditing(true)
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneButton,spaceButton], animated: false)
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    private func getPeople(product: String, type: String) -> [String] {
        let temp = product
        let tempTypePeople = (type == "Nhập Hàng") ? "Người Nhập Hàng" : "Khách Hàng"
        var arrPeople = [String]()
        let entityDescription = NSEntityDescription.entity(forEntityName: "People", in: context)
        let fetchRequest = NSFetchRequest<NSDictionary>()
        fetchRequest.entity = entityDescription
        fetchRequest.includesPropertyValues = true
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "product == %@ && type == %@", temp, tempTypePeople)
        fetchRequest.propertiesToFetch = ["name"]
        fetchRequest.resultType = .dictionaryResultType
        do {
            let personList = try context.fetch(fetchRequest)
            let resultDict = personList as! [[String : String]]
            for r in resultDict {
                arrPeople.append(r["name"]!)
            }
            arrPeople.insert("", at: 0)
        } catch let error as NSError {
            print(error)
        }
        return arrPeople
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UpdateProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var item = 0
        if(txtProductName.isEditing) {
            item = product.count
        } else if(txtPeople.isEditing) {
            item = getPeople(product: txtProductName.text!, type: transaction).count
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var item = ""
        if(txtProductName.isEditing) {
            item = product[row]
        } else if(txtPeople.isEditing) {
            item = getPeople(product: txtProductName.text!, type: transaction)[row]
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(txtProductName.isEditing) {
            selectItem = product[row]
            txtProductName.text = selectItem
            if(tempProduct != txtProductName.text) {
                txtPeople.text = ""
                tempProduct = selectItem!
            }
        } else if(txtPeople.isEditing) {
            selectItem = getPeople(product: txtProductName.text!, type: transaction)[row]
            txtPeople.text = selectItem
        }
    }
    
}


