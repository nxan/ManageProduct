//
//  ProductCategoryViewController.swift
//  ManageProduct
//
//  Created by NXA on 2/21/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import CoreData

class ProductCategoryViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var tableView: UITableView!
    var productTextField: UITextField!
    var productArray = [Product]()
    
    @IBAction func displayAlertAddProduct(_ sender: Any) {
        let alertController = UIAlertController(title: "Thêm sản phẩm", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: productTextField)

        let okAction = UIAlertAction(title: "Thêm", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func productTextField(textField: UITextField!) {
        productTextField = textField
        productTextField.placeholder = "Ví dụ: Củ sen, Củ năng..."
        productTextField.autocapitalizationType = .sentences
    }

    func okHandler(alert: UIAlertAction) {
        let newItem = Product(context: self.context)
        newItem.name = productTextField.text
        self.productArray.append(newItem)
        self.saveItem()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
    }
    
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
        loadItem()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadData"), object: nil)        
    }
    
    @objc func loadData() {
        loadItem()
        self.tableView.reloadData()
    }
    
    private func loadItem() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            productArray = try context.fetch(request)
        } catch {
            print("Error reload data")
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
        } catch let error as NSError {
            print(error)
        }
        return arrProduct
    }

}

extension ProductCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getProductName().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = getProductName()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var empId = ""
            empId = (productArray[indexPath.row].name)!
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Product")
            let predicate = NSPredicate(format: "name = '\(empId)'")
            fetchRequest.predicate = predicate
            let objects = try! context.fetch(fetchRequest)
            for object in objects {
                context.delete(object as! NSManagedObject)
            }
            saveItem()
            self.productArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
}
