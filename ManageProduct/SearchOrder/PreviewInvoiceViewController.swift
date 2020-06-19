//
//  PreviewInvoiceViewController.swift
//  ManageProduct
//
//  Created by Nguyen Xuan An on 6/19/20.
//  Copyright © 2020 NXA. All rights reserved.
//

import UIKit
import MessageUI
import CoreData


class PreviewInvoiceViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var invoiceInfo: [String: AnyObject]!
    var transaction: [Transaction] = []
    var userInfo = "", beginDate = "", endDate = ""
    
    var invoiceComposer: InvoiceComposer!
    
    var HTMLContent: String!
    
    @IBAction func print(_ sender: Any) {
        let pInfo: UIPrintInfo = UIPrintInfo.printInfo()
        pInfo.outputType = UIPrintInfo.OutputType.general
        pInfo.jobName = webView.request?.url?.absoluteString ?? ""
        pInfo.orientation = UIPrintInfo.Orientation.portrait
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = pInfo
        printController.printFormatter = webView.viewPrintFormatter()
        printController.present(animated: true, completionHandler: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInvoiceAsHTML(orderId: "1", startTime: "07:00:00")
        // Do any additional setup after loading the view.
    }
    
    func createInvoiceAsHTML(orderId: String, startTime: String) {
        let time = Date()
        let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
        invoiceComposer = InvoiceComposer()
        if let invoiceHTML = invoiceComposer.renderInvoice(invoiceNumber: "#",
                                                           start: startTime,
                                                           end: "\(time.hour):\(minute)",
            items: transaction, userInfo: userInfo, beginDate: beginDate, endDate: endDate) {
            
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
