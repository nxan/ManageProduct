//
//  AddNewProductViewController.swift
//  ManageProduct
//
//  Created by NXA on 9/11/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit
import CoreData

struct Order {
    var productName: String
    var weight: Double
    var unit: Double
    var money: Double
}

class AddNewProductViewController: UITableViewController, UITextFieldDelegate {
    
    var tempProduct = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectItem = ""
    var product = [""]
    let peopleArray = [People]()
    var productArray = [Transaction]()
    var products: [Order] = []
    let datePicker = UIDatePicker()
    var numberOfSections = 11
    var heightSection: CGFloat = 0.1
    var heightRow: CGFloat = 0.0
    var flagadd = 3
    var flag4 = false, flag5 = false, flag6 = false, flag7 = false
    var flagHeader4 = false, flagHeader5 = false, flagHeader6 = false, flagHeader7 = false
    var flagFooter4 = false, flagFooter5 = false, flagFooter6 = false, flagFooter7 = false
    var flagDelete4 = false, flagDelete5 = false, flagDelete6 = false, flagDelete7 = false
    var sectionDelete = 0
    var scrollflag = false
    var money = 0.0, money4 = 0.0, money5 = 0.0, money6 = 0.0, money7 = 0.0
    var moneyall: Double = 0.0 {
        didSet {
            txtMoneyAll.text = MyDateTime.addCommaNumber(string: String(moneyall))
        }
    }
    
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
    
    
    @IBOutlet var txtProductName4: UITextField!
    @IBOutlet var txtWeight4: UITextField!
    @IBOutlet var txtUnit4: UITextField!
    @IBOutlet weak var txtMoney4: UITextField!
    
    
    @IBOutlet var txtProductName5: UITextField!
    @IBOutlet var txtWeight5: UITextField!
    @IBOutlet var txtUnit5: UITextField!
    @IBOutlet weak var txtMoney5: UITextField!
    
    @IBOutlet var txtProductName6: UITextField!
    @IBOutlet var txtWeight6: UITextField!
    @IBOutlet var txtUnit6: UITextField!
    @IBOutlet weak var txtMoney6: UITextField!
    
    
    @IBOutlet var txtProductName7: UITextField!
    @IBOutlet var txtWeight7: UITextField!
    @IBOutlet var txtUnit7: UITextField!
    @IBOutlet weak var txtMoney7: UITextField!
    
    @IBOutlet weak var txtMoneyAll: UITextField!
    
    @IBOutlet var lbSave: UINavigationBar!
    
    @IBOutlet var newTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerViewProduct()
        createPickerViewPeople()
        createToolbarPickerView()
        showDatePicker()
        txtPeople.isEnabled = true
        txtMoney.isEnabled = false
        txtMoney4.isEnabled = false
        txtMoney5.isEnabled = false
        txtMoney6.isEnabled = false
        txtMoney7.isEnabled = false
        txtDate.text = MyDateTime.getCurrentDate()
        txtMoney.text = "0"
        product = getProductName()
        txtPeople.autocapitalizationType = .words
        txtProductName.autocapitalizationType = .sentences
        txtProductName4.autocapitalizationType = .sentences
        txtProductName5.autocapitalizationType = .sentences
        txtProductName6.autocapitalizationType = .sentences
        txtProductName7.autocapitalizationType = .sentences
    }  
    
    override func viewWillAppear(_ animated: Bool) {
        if lblType.text != UserDefaults.standard.string(forKey: "key_Type") {
            refreshTextField()
        }
        lblType.text = UserDefaults.standard.string(forKey: "key_Type")
        if lblType.text == "Nhập Hàng" {
            lblPeopleType.text = "Người nhập hàng"
        } else {
            lblPeopleType.text = "Khách Hàng"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let userDefaultStore = UserDefaults.standard
        userDefaultStore.set(lblType.text, forKey: "peopleTypeFromParent")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            txtProductName.resignFirstResponder()
            txtPeople.resignFirstResponder()
            txtWeight.resignFirstResponder()
            txtUnit.resignFirstResponder()
            
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
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        moveTextField(textField: textField, moveDistance: -350, up: true)
//        if let picker = textField.inputView as? UIPickerView {
//            picker.selectRow(0, inComponent: 0, animated: false)
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        moveTextField(textField: textField, moveDistance: -350, up: false)
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
//        let moveDuration = 0.3
//        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
//        UIView.beginAnimations("animatedTextField", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(moveDuration)
//        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
//        UIView.commitAnimations()
//    }
    
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
        resetPickerView(txtProductName)
        resetPickerView(txtPeople)
    }
    
    private func resetPickerView(_ textField: UITextField) {
        if let picker = textField.inputView as? UIPickerView {
            picker.selectRow(0, inComponent: 0, animated: false)
        }
    }
   
    
    @IBAction func btnSave(_ sender: Any) {
        collectProduct()
        print(products)
        saveProduct(productName: products[0].productName, weight: products[0].weight, unit: products[0].unit, money: products[0].money)
        saveProduct(productName: products[1].productName, weight: products[1].weight, unit: products[1].unit, money: products[1].money)
        MyCoreData.saveItem()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func saveProduct(productName: String, weight: Double, unit: Double, money: Double) {
        let newItem = Transaction(context: self.context)
        newItem.id = UUID.init().uuidString
        newItem.productName = productName
        newItem.peopleType = txtPeople.text
        newItem.date = MyDateTime.convertStringToDate(string: txtDate.text!)
        newItem.unit = unit
        newItem.weight = weight
        newItem.money = money
        newItem.note = txtNote.text
        newItem.type = lblType.text
        newItem.isPay = false
        self.productArray.insert(newItem, at: 0)
    }
    
    func collectProduct() {
        if txtProductName.text != "" {
            products.append(Order(productName: txtProductName.text ?? "", weight: (MyDateTime.removeCommaNumber(string: txtWeight.text!)! as NSString).doubleValue,
                                  unit: (MyDateTime.removeCommaNumber(string: txtUnit.text!)! as NSString).doubleValue, money: (MyDateTime.removeCommaNumber(string: txtMoney.text!)! as NSString).doubleValue))
        }
        
        if txtProductName4.text != "" {
            products.append(Order(productName: txtProductName4.text ?? "", weight: (MyDateTime.removeCommaNumber(string: txtWeight4.text!)! as NSString).doubleValue,
            unit: (MyDateTime.removeCommaNumber(string: txtUnit4.text!)! as NSString).doubleValue, money: (MyDateTime.removeCommaNumber(string: txtMoney4.text!)! as NSString).doubleValue))
        }
        
        if txtProductName5.text != "" {
            products.append(Order(productName: txtProductName5.text ?? "", weight: (MyDateTime.removeCommaNumber(string: txtWeight5.text!)! as NSString).doubleValue,
            unit: (MyDateTime.removeCommaNumber(string: txtUnit5.text!)! as NSString).doubleValue, money: (MyDateTime.removeCommaNumber(string: txtMoney5.text!)! as NSString).doubleValue))
        }
        
        if txtProductName6.text != "" {
            products.append(Order(productName: txtProductName6.text ?? "", weight: (MyDateTime.removeCommaNumber(string: txtWeight6.text!)! as NSString).doubleValue,
            unit: (MyDateTime.removeCommaNumber(string: txtUnit6.text!)! as NSString).doubleValue, money: (MyDateTime.removeCommaNumber(string: txtMoney6.text!)! as NSString).doubleValue))
        }
        
        if txtProductName7.text != "" {
            products.append(Order(productName: txtProductName7.text ?? "", weight: (MyDateTime.removeCommaNumber(string: txtWeight7.text!)! as NSString).doubleValue,
            unit: (MyDateTime.removeCommaNumber(string: txtUnit7.text!)! as NSString).doubleValue, money: (MyDateTime.removeCommaNumber(string: txtMoney7.text!)! as NSString).doubleValue))
        }
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
            money = Double(txtUnit.text!)! * Double(txtWeight.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit.text = MyDateTime.addCommaNumber(string: txtUnit.text!)
            txtWeight.text = MyDateTime.addCommaNumber(string: txtWeight.text!)
            txtMoney.text = MyDateTime.addCommaNumber(string: txtMoney.text!)            
        } else {
            txtMoney.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtUnit4EditChanged(_ sender: Any) {
        txtUnit4.text = MyDateTime.removeCommaNumber(string: txtUnit4.text!)
        if(!(txtUnit4.text?.isEmpty)!) {
            txtUnit4.text = MyDateTime.addCommaNumber(string: txtUnit4.text!)
        }
        if(!(txtUnit4.text?.isEmpty)! && !(txtWeight4.text?.isEmpty)!) {
            txtUnit4.text = MyDateTime.removeCommaNumber(string: txtUnit4.text!)
            txtWeight4.text = MyDateTime.removeCommaNumber(string: txtWeight4.text!)
            txtMoney4.text = String(Double(txtUnit4.text!)! * Double(txtWeight4.text!)!)
            money4 = Double(txtUnit4.text!)! * Double(txtWeight4.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit4.text = MyDateTime.addCommaNumber(string: txtUnit4.text!)
            txtWeight4.text = MyDateTime.addCommaNumber(string: txtWeight4.text!)
            txtMoney4.text = MyDateTime.addCommaNumber(string: txtMoney4.text!)
        } else {
            txtMoney4.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtUnit5EditChanged(_ sender: Any) {
        txtUnit5.text = MyDateTime.removeCommaNumber(string: txtUnit5.text!)
        if(!(txtUnit5.text?.isEmpty)!) {
            txtUnit5.text = MyDateTime.addCommaNumber(string: txtUnit5.text!)
        }
        if(!(txtUnit5.text?.isEmpty)! && !(txtWeight5.text?.isEmpty)!) {
            txtUnit5.text = MyDateTime.removeCommaNumber(string: txtUnit5.text!)
            txtWeight5.text = MyDateTime.removeCommaNumber(string: txtWeight5.text!)
            txtMoney5.text = String(Double(txtUnit5.text!)! * Double(txtWeight5.text!)!)
            money5 = Double(txtUnit5.text!)! * Double(txtWeight5.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit5.text = MyDateTime.addCommaNumber(string: txtUnit5.text!)
            txtWeight5.text = MyDateTime.addCommaNumber(string: txtWeight5.text!)
            txtMoney5.text = MyDateTime.addCommaNumber(string: txtMoney5.text!)
        } else {
            txtMoney5.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtUnit6EditChanged(_ sender: Any) {
        txtUnit6.text = MyDateTime.removeCommaNumber(string: txtUnit6.text!)
        if(!(txtUnit6.text?.isEmpty)!) {
            txtUnit6.text = MyDateTime.addCommaNumber(string: txtUnit6.text!)
        }
        if(!(txtUnit6.text?.isEmpty)! && !(txtWeight6.text?.isEmpty)!) {
            txtUnit6.text = MyDateTime.removeCommaNumber(string: txtUnit6.text!)
            txtWeight6.text = MyDateTime.removeCommaNumber(string: txtWeight6.text!)
            txtMoney6.text = String(Double(txtUnit6.text!)! * Double(txtWeight6.text!)!)
            money6 = Double(txtUnit6.text!)! * Double(txtWeight6.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit6.text = MyDateTime.addCommaNumber(string: txtUnit6.text!)
            txtWeight6.text = MyDateTime.addCommaNumber(string: txtWeight6.text!)
            txtMoney6.text = MyDateTime.addCommaNumber(string: txtMoney6.text!)
        } else {
            txtMoney6.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtUnit7EditChanged(_ sender: Any) {
        txtUnit7.text = MyDateTime.removeCommaNumber(string: txtUnit7.text!)
        if(!(txtUnit7.text?.isEmpty)!) {
            txtUnit7.text = MyDateTime.addCommaNumber(string: txtUnit7.text!)
        }
        if(!(txtUnit7.text?.isEmpty)! && !(txtWeight7.text?.isEmpty)!) {
            txtUnit7.text = MyDateTime.removeCommaNumber(string: txtUnit7.text!)
            txtWeight7.text = MyDateTime.removeCommaNumber(string: txtWeight7.text!)
            txtMoney7.text = String(Double(txtUnit7.text!)! * Double(txtWeight7.text!)!)
            money7 = Double(txtUnit7.text!)! * Double(txtWeight7.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit7.text = MyDateTime.addCommaNumber(string: txtUnit7.text!)
            txtWeight7.text = MyDateTime.addCommaNumber(string: txtWeight7.text!)
            txtMoney7.text = MyDateTime.addCommaNumber(string: txtMoney7.text!)
        } else {
            txtMoney7.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    
    @IBAction func txtWeightEditChanged(_ sender: Any) {
        if(!(txtWeight.text?.isEmpty)!) {
            txtWeight.text = MyDateTime.removeCommaNumber(string: txtWeight.text!)
        }
        if(!(txtUnit.text?.isEmpty)! && !(txtWeight.text?.isEmpty)!) {
            txtUnit.text = MyDateTime.removeCommaNumber(string: txtUnit.text!)
            txtMoney.text = String(Double(txtUnit.text!)! * Double(txtWeight.text!)!)
            money = Double(txtUnit.text!)! * Double(txtWeight.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit.text = MyDateTime.addCommaNumber(string: txtUnit.text!)
            txtMoney.text = MyDateTime.addCommaNumber(string: txtMoney.text!)
            
        } else {
            txtMoney.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtWeigh4tEditChanged(_ sender: Any) {
        if(!(txtWeight4.text?.isEmpty)!) {
            txtWeight4.text = MyDateTime.removeCommaNumber(string: txtWeight4.text!)
        }
        if(!(txtUnit4.text?.isEmpty)! && !(txtWeight4.text?.isEmpty)!) {
            txtUnit4.text = MyDateTime.removeCommaNumber(string: txtUnit4.text!)
            txtMoney4.text = String(Double(txtUnit4.text!)! * Double(txtWeight4.text!)!)
            money4 = Double(txtUnit4.text!)! * Double(txtWeight4.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit4.text = MyDateTime.addCommaNumber(string: txtUnit4.text!)
            txtMoney4.text = MyDateTime.addCommaNumber(string: txtMoney4.text!)
        } else {
            txtMoney4.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtWeight5EditChanged(_ sender: Any) {
        if(!(txtWeight5.text?.isEmpty)!) {
            txtWeight5.text = MyDateTime.removeCommaNumber(string: txtWeight5.text!)
        }
        if(!(txtUnit5.text?.isEmpty)! && !(txtWeight5.text?.isEmpty)!) {
            txtUnit5.text = MyDateTime.removeCommaNumber(string: txtUnit5.text!)
            txtMoney5.text = String(Double(txtUnit5.text!)! * Double(txtWeight5.text!)!)
            money5 = Double(txtUnit5.text!)! * Double(txtWeight5.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit5.text = MyDateTime.addCommaNumber(string: txtUnit5.text!)
            txtMoney5.text = MyDateTime.addCommaNumber(string: txtMoney5.text!)
        } else {
            txtMoney5.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtWeight6EditChanged(_ sender: Any) {
        if(!(txtWeight6.text?.isEmpty)!) {
            txtWeight6.text = MyDateTime.removeCommaNumber(string: txtWeight6.text!)
        }
        if(!(txtUnit6.text?.isEmpty)! && !(txtWeight6.text?.isEmpty)!) {
            txtUnit6.text = MyDateTime.removeCommaNumber(string: txtUnit6.text!)
            txtMoney6.text = String(Double(txtUnit6.text!)! * Double(txtWeight6.text!)!)
            money6 = Double(txtUnit6.text!)! * Double(txtWeight6.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit6.text = MyDateTime.addCommaNumber(string: txtUnit6.text!)
            txtMoney6.text = MyDateTime.addCommaNumber(string: txtMoney6.text!)
        } else {
            txtMoney6.text = "0.0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtWeigh7tEditChanged(_ sender: Any) {
        if(!(txtWeight7.text?.isEmpty)!) {
            txtWeight7.text = MyDateTime.removeCommaNumber(string: txtWeight7.text!)
        }
        if(!(txtUnit7.text?.isEmpty)! && !(txtWeight7.text?.isEmpty)!) {
            txtUnit7.text = MyDateTime.removeCommaNumber(string: txtUnit7.text!)
            txtMoney7.text = String(Double(txtUnit7.text!)! * Double(txtWeight7.text!)!)
            money7 = Double(txtUnit7.text!)! * Double(txtWeight7.text!)!
            moneyall = money + money4 + money5 + money6 + money7
            txtUnit7.text = MyDateTime.addCommaNumber(string: txtUnit7.text!)
            txtMoney7.text = MyDateTime.addCommaNumber(string: txtMoney7.text!)
        } else {
            txtMoney7.text = "0"
            txtMoneyAll.text = "0.0"
        }
    }
    
    @IBAction func txtWeightDidEnd(_ sender: Any) {
        txtWeight.text = MyDateTime.addCommaNumber(string: txtWeight.text!)
    }
    
    @IBAction func txtWeight4DidEnd(_ sender: Any) {
        if flag4 {
            txtWeight4.text = MyDateTime.addCommaNumber(string: txtWeight4.text!)
        }
    }
    
    @IBAction func txtWeight5DidEnd(_ sender: Any) {
        if flag5 {
            txtWeight5.text = MyDateTime.addCommaNumber(string: txtWeight5.text!)
        }
    }
    
    @IBAction func txtWeight6DidEnd(_ sender: Any) {
        if flag6 {
            txtWeight6.text = MyDateTime.addCommaNumber(string: txtWeight6.text!)
        }
    }
    
    @IBAction func txtWeight7DidEnd(_ sender: Any) {
        if flag7 {
            txtWeight7.text = MyDateTime.addCommaNumber(string: txtWeight7.text!)
        }
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
            txtProductName4.inputView = nil
            txtProductName5.inputView = nil
            txtProductName6.inputView = nil
            txtProductName7.inputView = nil
            refreshTextField()
        } else {
            txtProductName.inputView = typePicker
            txtProductName4.inputView = typePicker
            txtProductName5.inputView = typePicker
            txtProductName6.inputView = typePicker
            txtProductName7.inputView = typePicker
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
            txtProductName4.inputAccessoryView = nil
            txtProductName5.inputAccessoryView = nil
            txtProductName6.inputAccessoryView = nil
            txtProductName7.inputAccessoryView = nil
            txtPeople.inputAccessoryView = nil
        } else {
            txtProductName.inputAccessoryView = toolbar
            txtProductName4.inputAccessoryView = toolbar
            txtProductName5.inputAccessoryView = toolbar
            txtProductName6.inputAccessoryView = toolbar
            txtProductName7.inputAccessoryView = toolbar
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
    
    func showDatePicker() {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneButton,spaceButton], animated: false)
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        case 8:
            return 1
        case 9:
            return 1
        default:
            return 5
        }
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3  && indexPath.row == 4  && flagadd < 8 {
            heightSection = UITableView.automaticDimension
            heightRow = UITableView.automaticDimension
            flagadd += 1
            reloadView()
        } else if indexPath.section == 4 && indexPath.row == 4 {
            sectionDelete = 4
            flagDelete4 = true
            flag4 = false
            flagHeader4 = false
            flagFooter4 = false
            flagadd -= 1
            reloadView()
            txtProductName4.text = ""
            txtUnit4.text = ""
            txtWeight4.text = ""
            txtMoney4.text = ""
            money4 = 0
            moneyall = money + money4 + money5 + money6 + money7
        } else if indexPath.section == 5 && indexPath.row == 4 {
            sectionDelete = 5
            flagDelete5 = true
            flag5 = false
            flagHeader5 = false
            flagFooter5 = false
            flagadd -= 1
            reloadView()
            txtProductName5.text = ""
            txtUnit5.text = ""
            txtWeight5.text = ""
            txtMoney5.text = ""
            money5 = 0
            moneyall = money + money4 + money5 + money6 + money7
        } else if indexPath.section == 6 && indexPath.row == 4 {
            sectionDelete = 6
            flagDelete6 = true
            flag6 = false
            flagHeader6 = false
            flagFooter6 = false
            flagadd -= 1
            reloadView()
            txtProductName6.text = ""
            txtUnit6.text = ""
            txtWeight6.text = ""
            txtMoney6.text = ""
            money6 = 0
            moneyall = money + money4 + money5 + money6 + money7
        } else if indexPath.section == 7 && indexPath.row == 4 {
            sectionDelete = 7
            flagDelete7 = true
            flag7 = false
            flagHeader7 = false
            flagFooter7 = false
            flagadd -= 1
            reloadView()
            txtProductName7.text = ""
            txtUnit7.text = ""
            txtWeight7.text = ""
            txtMoney7.text = ""
            money7 = 0
            moneyall = money + money4 + money5 + money6 + money7
        }
        if flagadd == 3 {
            flagHeader4 = false; flagHeader5 = false; flagHeader6 = false; flagHeader7 = false
            flagFooter4 = false; flagFooter5 = false; flagFooter6 = false; flagFooter7 = false
            flagDelete4 = false; flagDelete5 = false; flagDelete6 = false; flagDelete7 = false
            sectionDelete = 0
            reloadView()
            txtProductName7.text = ""
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            if (indexPath.section == flagadd && !flag4 && !flagDelete4) || (sectionDelete == 4 && !flagDelete4) {
                flag4 = true
                return heightRow
            } else if flag4 && !flagDelete4 {
                return UITableView.automaticDimension
            } else if flagDelete4 {
                return 0
            } else {
                return 0
            }
        }
        if indexPath.section == 5 {
            if (indexPath.section == flagadd && !flag5 && !flagDelete5) || (sectionDelete == 5 && !flagDelete5) {
                flag5 = true
                return heightRow
            } else if flag5 && !flagDelete5 {
                return UITableView.automaticDimension
            } else if flagDelete5 {
                return 0
            } else {
                return 0
            }
        }
        if indexPath.section == 6 {
            if (indexPath.section == flagadd && !flag6 && !flagDelete6) || (sectionDelete == 6 && !flagDelete6) {
                flag6 = true
                return heightRow
            } else if flag6 && !flagDelete6 {
                return UITableView.automaticDimension
            } else if flagDelete6 {
                return 0
            } else {
                return 0
            }
        }
        if indexPath.section == 7 {
            if (indexPath.section == flagadd && !flag7 && !flagDelete7) || (sectionDelete == 7 && !flagDelete7) {
                flag7 = true
                return heightRow
            } else if flag7 && !flagDelete7 {
                return UITableView.automaticDimension
            } else if flagDelete7 {
                return 0
            } else {
                return 0
            }
        }
        if indexPath.section == 9 {
            return 129.0
        }
        return UITableView.automaticDimension
    }
            
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
           if (indexPath.section == flagadd && !flag4 && !flagDelete4) || (sectionDelete == 4 && !flagDelete4) {
               flag4 = true
               return heightRow
           } else if flag4 && !flagDelete4 {
               return UITableView.automaticDimension
           } else if flagDelete4 {
               return 0
           } else {
               return 0
           }
       }
       if indexPath.section == 5 {
           if (indexPath.section == flagadd && !flag5 && !flagDelete5) || (sectionDelete == 5 && !flagDelete5) {
               flag5 = true
               return heightRow
           } else if flag5 && !flagDelete5 {
               return UITableView.automaticDimension
           } else if flagDelete5 {
               return 0
           } else {
               return 0
           }
       }
       if indexPath.section == 6 {
           if (indexPath.section == flagadd && !flag6 && !flagDelete6) || (sectionDelete == 6 && !flagDelete6) {
               flag6 = true
               return heightRow
           } else if flag6 && !flagDelete6 {
               return UITableView.automaticDimension
           } else if flagDelete6 {
               return 0
           } else {
               return 0
           }
       }
       if indexPath.section == 7 {
           if (indexPath.section == flagadd && !flag7 && !flagDelete7) || (sectionDelete == 7 && !flagDelete7) {
               flag7 = true
               return heightRow
           } else if flag7 && !flagDelete7 {
               return UITableView.automaticDimension
           } else if flagDelete7 {
               return 0
           } else {
               return 0
           }
       }
       if indexPath.section == 9 {
           return 129.0
       }
       return UITableView.automaticDimension
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Bạn muốn nhập hàng hay bán hàng?"
        case 1:
            return "Cài đặt"
        case 2:
            return "Thông tin cá nhân"
        case 3:
            return "Các mặt hàng"
        case 8:
            return "Chi phí đơn hàng"
        case 9:
            return "Khác"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 4:
            if (section == flagadd && !flagHeader4 && !flagDelete4) || (sectionDelete == 4 && !flagDelete4) {
                flagHeader4 = true
                return heightRow
            } else if flagHeader4 && !flagDelete4 {
                return UITableView.automaticDimension
            } else if flagDelete4 {
                return 0.1
            }
        case 5:
            if (section == flagadd && !flag5 && !flagDelete5) || (sectionDelete == 5 && !flagDelete5) {
                flagHeader5 = true
                return heightRow
            } else if (flagHeader5 && !flagDelete5) || (flag5 && !flagDelete5) {
                return UITableView.automaticDimension
            } else if flagDelete5 {
                return 0.1
            }
        case 6:
            if (section == flagadd && !flag6 && !flagDelete6) || (sectionDelete == 6 && !flagDelete6) {
                flagHeader6 = true
                return heightRow
            } else if flagHeader6 && !flagDelete6 {
                return UITableView.automaticDimension
            } else if flagDelete6 {
                return 0.1
            }
        case 7:
            if (section == flagadd && !flag7 && !flagDelete7) || (sectionDelete == 7 && !flagDelete7) {
                flagHeader7 = true
                return heightRow
            } else if flagHeader7 && !flagDelete7 {
                return UITableView.automaticDimension
            } else if flagDelete7 {
                return 0.1
            }
        default:
            return UITableView.automaticDimension
        }
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 4:
            if (section == flagadd && !flagFooter4 && !flagDelete4) || (sectionDelete == 4 && !flagDelete4) {
                flagFooter4 = true
                return heightRow
            } else if flagFooter4 && !flagDelete4 {
                return UITableView.automaticDimension
            } else if flagDelete4 {
                return 0.1
            }
        case 5:
           if (section == flagadd && !flagFooter5 && !flagDelete5) || (sectionDelete == 5 && !flagDelete5) {
                flagFooter5 = true
                return heightRow
            } else if flagFooter5 && !flagDelete5 {
                return UITableView.automaticDimension
            } else if flagDelete5 {
                return 0.1
            }
        case 6:
            if (section == flagadd && !flagFooter6 && !flagDelete6) || (sectionDelete == 6 && !flagDelete6) {
                flagFooter6 = true
                return heightRow
            } else if flagFooter6 && !flagDelete6 {
                return UITableView.automaticDimension
            } else if flagDelete6 {
                return 0.1
            }
        case 7:
           if (section == flagadd && !flagFooter7 && !flagDelete7) || (sectionDelete == 7 && !flagDelete7) {
                flagFooter7 = true
                return heightRow
            } else if flagFooter7 && !flagDelete7 {
                return UITableView.automaticDimension
            } else if flagDelete7 {
                return 0.1
            }
        default:
            return UITableView.automaticDimension
        }
        return 0.1
    }
    
}

extension AddNewProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var item = 0
        if(txtProductName.isEditing) || (txtProductName4.isEditing) || (txtProductName5.isEditing) || (txtProductName6.isEditing) || (txtProductName7.isEditing) {
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
        if(txtProductName.isEditing) || (txtProductName4.isEditing) || (txtProductName5.isEditing) || (txtProductName6.isEditing) || (txtProductName7.isEditing) {
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
                //txtPeople.text = ""
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
        } else if txtProductName4.isEditing {
            selectItem = product[row]
            txtProductName4.text = selectItem
            if(tempProduct != txtProductName4.text) {
                //txtPeople.text = ""
                tempProduct = selectItem
            }
        } else if txtProductName5.isEditing {
            selectItem = product[row]
            txtProductName5.text = selectItem
            if(tempProduct != txtProductName5.text) {
                //txtPeople.text = ""
                tempProduct = selectItem
            }
        } else if txtProductName6.isEditing {
            selectItem = product[row]
            txtProductName6.text = selectItem
            if(tempProduct != txtProductName6.text) {
                //txtPeople.text = ""
                tempProduct = selectItem
            }
        } else if txtProductName7.isEditing {
            selectItem = product[row]
            txtProductName7.text = selectItem
            if(tempProduct != txtProductName7.text) {
                //txtPeople.text = ""
                tempProduct = selectItem
            }
        }
    }
}


final class ContentSizedTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}
