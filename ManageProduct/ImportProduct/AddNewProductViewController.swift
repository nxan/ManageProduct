//
//  AddNewProductViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/11/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import CoreData

class AddNewProductViewController: UITableViewController, UITextFieldDelegate {
    
    var tempProduct = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectItem = ""
    var product = [""]
    let peopleArray = [People]()
    var productArray = [Transaction]()
    let datePicker = UIDatePicker()
    
    @IBOutlet var txtProductName: UITextField!
    @IBOutlet var txtPeople: UITextField!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var txtWeight: UITextField!
    @IBOutlet var txtMoney: UITextField!
    @IBOutlet var txtUnit: UITextField!
    @IBOutlet var txtNote: UITextField!
    @IBOutlet var SwitchText: UISwitch!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblPeopleType: UILabel!
    
    
    @IBOutlet var lbSave: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerViewProduct()
        createPickerViewPeople()
        createToolbarPickerView()
        showDatePicker()
        txtPeople.isEnabled = false
        txtMoney.isEnabled = false
        txtDate.text = MyDateTime.getCurrentDate()
        txtMoney.text = "0"
        product = getProductName()
        txtPeople.autocapitalizationType = .words
        txtProductName.autocapitalizationType = .sentences
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblType.text = UserDefaults.standard.string(forKey: "key_Type")
        if lblType.text == "Nhập Hàng" {
            lblPeopleType.text = "Người nhập hàng"
        } else {
            lblPeopleType.text = "Khách Hàng"
        }
        refreshTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let userDefaultStore = UserDefaults.standard
        userDefaultStore.set(lblType.text, forKey: "peopleTypeFromParent")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSwitch(_ sender: Any) {
        if SwitchText.isOn {
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
    
    @IBAction func txtProductNameDidChanged(_ sender: Any) {}
    
    private func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField: textField, moveDistance: -350, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField: textField, moveDistance: -350, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animatedTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    private func boldString(text1: String) -> NSAttributedString {
        let text = text1
        let attributedString = NSMutableAttributedString(string: "Bạn đã chọn ")
        let attributedString2 = NSMutableAttributedString(string: " .Vui lòng điền đẩy đủ thông tin.")
        let att = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let boldAge = NSMutableAttributedString(string: text, attributes: att)
        attributedString.append(boldAge)
        attributedString.append(attributedString2)
        return attributedString
    }
    
    private func refreshTextField() {
        txtProductName.text = ""; txtPeople.text = ""; txtUnit.text = ""; txtWeight.text = ""; txtMoney.text = "0"; txtNote.text = "";
    }
    
    @IBAction func btnSave(_ sender: Any) {
        let newItem = Transaction(context: self.context)
        newItem.id = UUID.init().uuidString
        newItem.productName = txtProductName.text
        newItem.peopleType = txtPeople.text
        newItem.date = MyDateTime.convertStringToDate(string: txtDate.text!)
        newItem.unit = (MyDateTime.removeCommaNumber(string: txtUnit.text!)! as NSString).doubleValue
        newItem.weight = (MyDateTime.removeCommaNumber(string: txtWeight.text!)! as NSString).doubleValue
        newItem.money = (MyDateTime.removeCommaNumber(string: txtMoney.text!)! as NSString).doubleValue
        newItem.note = txtNote.text
        newItem.type = lblType.text
        newItem.isPay = false
        self.productArray.insert(newItem, at: 0)
        MyCoreData.saveItem()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
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
            txtMoney.text = String(Double(txtUnit.text!)! * Double(txtWeight.text!)!)
            txtUnit.text = MyDateTime.addCommaNumber(string: txtUnit.text!)
            txtWeight.text = MyDateTime.addCommaNumber(string: txtWeight.text!)
            txtMoney.text = MyDateTime.addCommaNumber(string: txtMoney.text!)
        } else {
            txtMoney.text = "0"
        }
    }
    
    @IBAction func txtWeightEditChanged(_ sender: Any) {
        if(!(txtWeight.text?.isEmpty)!) {
            txtWeight.text = MyDateTime.removeCommaNumber(string: txtWeight.text!)
        }
        if(!(txtUnit.text?.isEmpty)! && !(txtWeight.text?.isEmpty)!) {
            txtUnit.text = MyDateTime.removeCommaNumber(string: txtUnit.text!)
            txtMoney.text = String(Double(txtUnit.text!)! * Double(txtWeight.text!)!)
            txtUnit.text = MyDateTime.addCommaNumber(string: txtUnit.text!)
            txtMoney.text = MyDateTime.addCommaNumber(string: txtMoney.text!)
        } else {
            txtMoney.text = "0"
        }
    }
    
    @IBAction func txtWeightDidEnd(_ sender: Any) {
        txtWeight.text = MyDateTime.addCommaNumber(string: txtWeight.text!)
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
    
    private func getPeopleCustomer(tempTypePeople: String) -> [String] {
        var arrProduct = [String]()
        let entityDescription = NSEntityDescription.entity(forEntityName: "People", in: context)
        let fetchRequest = NSFetchRequest<NSDictionary>()
        fetchRequest.entity = entityDescription
        fetchRequest.includesPropertyValues = true
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "type == %@", tempTypePeople)
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
    
    private func createPickerViewProduct() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
        if(SwitchText.isOn) {
            txtProductName.inputView = nil
            refreshTextField()
        } else {
            txtProductName.inputView = typePicker
            refreshTextField()
        }
    }
    
    private func createPickerViewPeople() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
        if(SwitchText.isOn) {
            txtPeople.inputView = nil
        } else {
            txtPeople.inputView = typePicker
        }
    }
    
    private func createToolbarPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(AddNewProductViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        if(SwitchText.isOn) {
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
        view.endEditing(true)
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
       
}

extension AddNewProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var item = 0
        if(txtProductName.isEditing) {
            item = product.count
        } else if(txtPeople.isEditing) {
            if(lblType.text == "Bán Hàng") {
                item = getPeopleCustomer(tempTypePeople: "Khách Hàng").count
            } else {
                item = getPeople(product: txtProductName.text!, type: lblType.text!).count
            }
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var item = ""
        if(txtProductName.isEditing) {
            item = product[row]
        } else if(txtPeople.isEditing) {
            if(lblType.text == "Bán Hàng") {
                item = getPeopleCustomer(tempTypePeople: "Khách Hàng")[row]
            } else {
                item = getPeople(product: txtProductName.text!, type: lblType.text!)[row]
            }
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(txtProductName.isEditing) {
            selectItem = product[row]
            txtProductName.text = selectItem
            if(tempProduct != txtProductName.text) {
                txtPeople.text = ""
                tempProduct = selectItem
            }            
        } else if(txtPeople.isEditing) {
            if(lblType.text == "Bán Hàng") {
                selectItem = getPeopleCustomer(tempTypePeople: "Khách Hàng")[row]
                txtPeople.text = selectItem
            } else {
                selectItem = getPeople(product: txtProductName.text!, type: lblType.text!)[row]
                txtPeople.text = selectItem
            }
        }
    }
    
    
}






