//
//  AddNewProductViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/11/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import CoreData

class AddNewProductViewController: UIViewController {
    
    var tempProduct = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectItem = ""
    let product = ["", "Củ Sen", "Củ Hành"]
    let peopleArray = [People]()
    var productArray = [Product]()
    let datePicker = UIDatePicker()
    
    @IBOutlet var txtProductName: FloatingTextField!
    @IBOutlet var txtPeople: FloatingTextField!
    @IBOutlet var txtDate: FloatingTextField!
    @IBOutlet var txtWeight: FloatingTextField!
    @IBOutlet var txtMoney: FloatingTextField!
    @IBOutlet var txtUnit: FloatingTextField!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var lbInfo: UILabel!
    @IBOutlet var txtNote: FloatingTextField!
    @IBOutlet var lbSwitch: UILabel!
    @IBOutlet var SwitchText: UISwitch!
    @IBOutlet var lbSave: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerViewProduct()
        createPickerViewPeople()
        createToolbarPickerView()
        showDatePicker()
        txtPeople.isEnabled = false
        txtMoney.isEnabled = false
        txtDate.text = getCurrentDate()
        txtMoney.text = "0"
        lbInfo.attributedText = boldString(text1: "Nhập Hàng")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            lbInfo.attributedText = boldString(text1: "Nhập Hàng")
            refreshTextField()
            break
        case 1:
            lbInfo.attributedText = boldString(text1: "Bán Hàng")
            refreshTextField()
            break
        default:
            break
        }
    }
    
    @IBAction func btnSwitch(_ sender: Any) {
        if SwitchText.isOn {
            lbSwitch.text = "Bật"
            createPickerViewProduct()
            createPickerViewPeople()
            createToolbarPickerView()
            txtPeople.isEnabled = true
        } else {
            lbSwitch.text = "Tắt"
            createPickerViewProduct()
            createPickerViewPeople()
            createToolbarPickerView()
            txtPeople.isEnabled = false
            
        }
    }
    
    @IBAction func txtProductNameDidChanged(_ sender: Any) {
        
    }
    
    private func boldString(text1: String) -> NSAttributedString {
        let text = text1
        let attributedString = NSMutableAttributedString(string: "Bạn đã chọn ")
        let attributedString2 = NSMutableAttributedString(string: " .Vui lòng điền đẩy đủ thông tin.")
        let att = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        let boldAge = NSMutableAttributedString(string: text, attributes: att)
        attributedString.append(boldAge)
        attributedString.append(attributedString2)
        return attributedString
    }
    
    private func refreshTextField() {
        txtProductName.text = ""; txtPeople.text = ""; txtUnit.text = ""; txtWeight.text = ""; txtMoney.text = "0"; txtNote.text = "";
    }
    
    @IBAction func btnSave(_ sender: Any) {
        let newItem = Product(context: self.context)
        newItem.id = UUID.init().uuidString
        newItem.productName = txtProductName.text
        newItem.peopleType = txtPeople.text
        newItem.date = convertStringToDate(string: txtDate.text!)
        newItem.unit = (removeCommaNumber(string: txtUnit.text!) as NSString).doubleValue
        newItem.weight = (removeCommaNumber(string: txtWeight.text!) as NSString).doubleValue
        newItem.money = (removeCommaNumber(string: txtMoney.text!) as NSString).doubleValue
        newItem.note = txtNote.text
        newItem.type = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)        
        self.productArray.insert(newItem, at: 0)
        self.saveItem()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func txtUnitEditChanged(_ sender: Any) {
        txtUnit.text = removeCommaNumber(string: txtUnit.text!)
        if(!(txtUnit.text?.isEmpty)!) {
            txtUnit.text = addCommaNumber(string: txtUnit.text!)
        }
        if(!(txtUnit.text?.isEmpty)! && !(txtWeight.text?.isEmpty)!) {
            txtUnit.text = removeCommaNumber(string: txtUnit.text!)
            txtWeight.text = removeCommaNumber(string: txtWeight.text!)
            txtMoney.text = String(Int(txtUnit.text!)! * Int(txtWeight.text!)!)
            txtUnit.text = addCommaNumber(string: txtUnit.text!)
            txtWeight.text = addCommaNumber(string: txtWeight.text!)
            txtMoney.text = addCommaNumber(string: txtMoney.text!)
        } else {
            txtMoney.text = "0"
        }
    }
    
    @IBAction func txtWeightEditChanged(_ sender: Any) {
        txtWeight.text = removeCommaNumber(string: txtWeight.text!)
        if(!(txtWeight.text?.isEmpty)!) {
            txtWeight.text = addCommaNumber(string: txtWeight.text!)
        }
        if(!(txtUnit.text?.isEmpty)! && !(txtWeight.text?.isEmpty)!) {
            txtUnit.text = removeCommaNumber(string: txtUnit.text!)
            txtWeight.text = removeCommaNumber(string: txtWeight.text!)
            txtMoney.text = String(Double(txtUnit.text!)! * Double(txtWeight.text!)!)
            txtUnit.text = addCommaNumber(string: txtUnit.text!)
            txtWeight.text = addCommaNumber(string: txtWeight.text!)
            txtMoney.text = addCommaNumber(string: txtMoney.text!)
        } else {
            txtMoney.text = "0"
        }
    }
    
    private func convertStringToDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: string)
        return date!
    }        
    
    private func addCommaNumber(string: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSize = 3
        let formattedNumber = numberFormatter.string(from: NSNumber(value:Double(string)!))
        return formattedNumber!
    }
    
    private func removeCommaNumber(string: String) -> String {
        var newString = ""
        newString = string.replacingOccurrences(of: ",", with: "")
        return newString
    }
    
    private func formatCurrency(string: String) -> String{
        let price = Int(string)
        let curFormatter : NumberFormatter = NumberFormatter()
        curFormatter.numberStyle = .currency
        curFormatter.currencyCode = "USD"
        curFormatter.maximumFractionDigits = 0
        let total = curFormatter.string(from: price! as NSNumber)
        return total!
    }
    
    private func getCurrentDate() -> String {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "dd/MM/yyyy"
        let result = formater.string(from: date)
        return result
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
    
    private func saveItem() {
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Error save")
        }
    }
    
    private func getPeople(product: String, type: Int) -> [String]{
        let temp = product
        let tempTypePeople = (type == 0) ? "Người Nhập Hàng" : "Khách Hàng"
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
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
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
            item = getPeople(product: txtProductName.text!, type: segmentedControl.selectedSegmentIndex).count
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var item = ""
        if(txtProductName.isEditing) {
            item = product[row]
        } else if(txtPeople.isEditing) {
            item = getPeople(product: txtProductName.text!, type: segmentedControl.selectedSegmentIndex)[row]
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
            selectItem = getPeople(product: txtProductName.text!, type: segmentedControl.selectedSegmentIndex)[row]
            txtPeople.text = selectItem
        }
    }
    
    
}






