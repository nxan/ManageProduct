//
//  PreviewViewController.swift
//  ManageProduct
//
//  Created by Nguyen Xuan An on 6/4/20.
//  Copyright © 2020 NXA. All rights reserved.
//

import UIKit
import MessageUI
import CoreData


class PreviewViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var invoiceInfo: [String: AnyObject]!
    var transaction: [Transaction] = []
    var id = "", productName = "", people = "", money = "", weight = "", unit = "", date = "", note = ""
    
    var invoiceComposer: ProductInvoiceComposer!
    
    var HTMLContent: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
        createInvoiceAsHTML(orderId: "1", startTime: "07:00:00")
        // Do any additional setup after loading the view.
    }
    
    func createInvoiceAsHTML(orderId: String, startTime: String) {
        let time = Date()
        let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
        invoiceComposer = ProductInvoiceComposer()
        if let invoiceHTML = invoiceComposer.renderInvoice(invoiceNumber: "#" + id ,
                                                           start: startTime,
                                                           end: "\(time.hour):\(minute)",
                                                           deskInfo: "aaa", userInfo: people,
                                                           items: transaction,
                                                           totalAmount: money, fee: "0%", total: money, product: productName, quantity: weight, unit: unit) {
            
            webView.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
    private func loadItem() {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            transaction = try context.fetch(request)
        } catch {
            print("Error reload data")
        }
    }
}

extension Date {
    var hour: Int { return Calendar.autoupdatingCurrent.component(.hour, from: self) }
    var minute: Int { return Calendar.autoupdatingCurrent.component(.minute, from: self) }
    
    
}
