//
//  GroupTimeOrderViewController.swift
//  ManageProduct
//
//  Created by NXA on 10/6/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import UIKit

class GroupTimeOrderViewController: UIViewController {
    
    let pickerAnimationDuration = 0.40 // duration for the animation to slide the date picker into view
    let datePickerTag           = 99   // view tag identifiying the date picker view
    
    let titleKey = "title" // key for obtaining the data source item's title
    let dateKey  = "date"  // key for obtaining the data source item's date value
    
    // keep track of which rows have date cells
    let dateStartRow = 1
    let dateEndRow   = 2
    
    let dateCellID       = "cell";       // the cells with the start or end date //cell
    let datePickerCellID = "pickercell"; // the cell containing the date picker //pickercekk
    let otherCellID      = "othercell";      // the remaining cells at the end //othercell
    var dataArray: [[String: AnyObject]] = []
    var dateFormatter = DateFormatter()
    
    // keep track which indexPath points to the cell with UIDatePicker
    var datePickerIndexPath: NSIndexPath?
    
    var pickerCellRowHeight: CGFloat = 216
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func btnDone(_ sender: Any) {
        let targetedCellIndexPath: NSIndexPath = NSIndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: targetedCellIndexPath as IndexPath)
        let dateString = cell?.detailTextLabel?.text
                
        let targetedCellIndexPathEnd: NSIndexPath = NSIndexPath(row: 2, section: 0)
        let cellEnd = tableView.cellForRow(at: targetedCellIndexPathEnd as IndexPath)
        var dateStringEnd = cellEnd?.detailTextLabel?.text
        
        if(dateStringEnd == nil) {
            dateStringEnd = MyDateTime.getCurrentDate()
        }
        UserDefaults.standard.set(dateString, forKey: "BeginOrderDate")
        UserDefaults.standard.set(dateStringEnd, forKey: "EndOrderDate")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadOrderByDate"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datepickerAction(_ sender: UIDatePicker) {
        var targetedCellIndexPath: NSIndexPath?
        
        if self.hasInlineDatePicker() {
            // inline date picker: update the cell's date "above" the date picker cell
            //
            targetedCellIndexPath = IndexPath(row: datePickerIndexPath!.row - 1, section: 0) as NSIndexPath
            
        } else {
            // external date picker: update the current "selected" cell's date
            targetedCellIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
        }
        
        let cell = tableView.cellForRow(at: targetedCellIndexPath! as IndexPath)
        let targetedDatePicker = sender
        
        // update our data model
        var itemData = dataArray[targetedCellIndexPath!.row]
        itemData[dateKey] = targetedDatePicker.date as AnyObject
        dataArray[targetedCellIndexPath!.row] = itemData
        
        // update the cell's date string
        cell?.detailTextLabel?.text = dateFormatter.string(from: targetedDatePicker.date)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup our data source
        let itemOne = [titleKey : "Chọn khoảng thời gian bạn muốn tìm kiếm: "]
        let itemTwo = [titleKey : "Ngày bắt đầu", dateKey : UserDefaults.standard.string(forKey: "BeginOrderDate") ?? NSDate()] as [String : Any]
        let itemThree = [titleKey : "Ngày kết thúc", dateKey : UserDefaults.standard.string(forKey: "EndOrderDate") ?? NSDate()] as [String : Any]
        dataArray = [itemOne as Dictionary<String, AnyObject>, itemTwo as Dictionary<String, AnyObject>, itemThree as Dictionary<String, AnyObject>]
        
        dateFormatter.dateStyle = .medium // show short-style date format
        dateFormatter.dateFormat = "dd/MM/yyyy"
//        dateFormatter.timeStyle = .short
        
        // if the local changes while in the background, we need to be notified so we can update the date
        // format in the table view cells
        //
        NotificationCenter.default.addObserver(self, selector: #selector(GroupTimeOrderViewController.localeChanged(notif:)), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
    }
    
    @objc func localeChanged(notif: NSNotification) {
        tableView.reloadData()
    }
    
}

extension GroupTimeOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasInlineDatePicker() {
            // we have a date picker, so allow for it in the number of rows in this section
            return dataArray.count + 1;
        }
        
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var cellID = otherCellID
        
        if indexPathHasPicker(indexPath: indexPath as NSIndexPath) {
            // the indexPath is the one containing the inline date picker
            cellID = datePickerCellID     // the current/opened date picker cell
        } else if indexPathHasDate(indexPath: indexPath as NSIndexPath) {
            // the indexPath is one that contains the date information
            cellID = dateCellID       // the start/end date cells
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellID) // pickercell vs CellId
        
        
        if indexPath.row == 0 {
            // we decide here that first cell in the table is not selectable (it's just an indicator)
            cell?.selectionStyle = .none;
        }
        
        // if we have a date picker open whose cell is above the cell we want to update,
        // then we have one more cell than the model allows
        //
        var modelRow = indexPath.row
        if (datePickerIndexPath != nil && (datePickerIndexPath?.row)! <= indexPath.row) {
            modelRow -= 1
        }
        
        let itemData = dataArray[modelRow]
        
        if cellID == dateCellID {
            // we have either start or end date cells, populate their date field
            //
            cell?.textLabel?.text = itemData[titleKey] as? String
//            cell?.detailTextLabel?.text = self.dateFormatter.string(from: (itemData[dateKey] as! NSDate) as Date)
            cell?.detailTextLabel?.text = itemData[dateKey] as? String
        } else if cellID == otherCellID {
            // this cell is a non-date cell, just assign it's text label
            //
            cell?.textLabel?.text = itemData[titleKey] as? String
        }
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        if cell?.reuseIdentifier == dateCellID {
            displayInlineDatePickerForRowAtIndexPath(indexPath: indexPath as NSIndexPath)
        } else {
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPathHasPicker(indexPath: indexPath as NSIndexPath) ? pickerCellRowHeight : tableView.rowHeight)
    }
    
    func hasInlineDatePicker() -> Bool {
        return datePickerIndexPath != nil
    }
    
    func indexPathHasPicker(indexPath: NSIndexPath) -> Bool {
        return hasInlineDatePicker() && datePickerIndexPath?.row == indexPath.row
    }
    
    func indexPathHasDate(indexPath: NSIndexPath) -> Bool {
        var hasDate = false
        
        if (indexPath.row == dateStartRow) || (indexPath.row == dateEndRow || (hasInlineDatePicker() && (indexPath.row == dateEndRow + 1))) {
            hasDate = true
        }
        return hasDate
    }
    
    func displayInlineDatePickerForRowAtIndexPath(indexPath: NSIndexPath) {
        
        // display the date picker inline with the table content
        tableView.beginUpdates()
        
        var before = false // indicates if the date picker is below "indexPath", help us determine which row to reveal
        if hasInlineDatePicker() {
            before = (datePickerIndexPath?.row)! < indexPath.row
        }
        
        let sameCellClicked = (datePickerIndexPath?.row == indexPath.row + 1)
        
        // remove any date picker cell if it exists
        if self.hasInlineDatePicker() {
            
            tableView.deleteRows(at: [IndexPath(row: datePickerIndexPath!.row, section: 0)], with: .fade)
            datePickerIndexPath = nil
        }
        
        if !sameCellClicked {
            // hide the old date picker and display the new one
            let rowToReveal = (before ? indexPath.row - 1 : indexPath.row)
            let indexPathToReveal =  IndexPath(row: rowToReveal, section: 0)
            
            toggleDatePickerForSelectedIndexPath(indexPath: indexPathToReveal as NSIndexPath)
            datePickerIndexPath = IndexPath(row: indexPathToReveal.row + 1, section: 0) as NSIndexPath
        }
        
        // always deselect the row containing the start or end date
        tableView.deselectRow(at: indexPath as IndexPath, animated:true)
        
        tableView.endUpdates()
        
        // inform our date picker of the current date to match the current cell
        updateDatePicker()
    }
    
    func toggleDatePickerForSelectedIndexPath(indexPath: NSIndexPath) {
        
        tableView.beginUpdates()
        
        let indexPaths = [IndexPath(row: indexPath.row + 1, section: 0)]
        
        // check if 'indexPath' has an attached date picker below it
        if hasPickerForIndexPath(indexPath: indexPath) {
            // found a picker below it, so remove it
            tableView.deleteRows(at: indexPaths as [IndexPath], with: .fade)
        } else {
            // didn't find a picker below it, so we should insert it
            tableView.insertRows(at: indexPaths as [IndexPath], with: .fade)
        }
        
        tableView.endUpdates()
    }
    
    func updateDatePicker() {
        if let indexPath = datePickerIndexPath {
            let associatedDatePickerCell = tableView.cellForRow(at: indexPath as IndexPath)
            if let targetedDatePicker = associatedDatePickerCell?.viewWithTag(datePickerTag) as! UIDatePicker? {
                let itemData = dataArray[self.datePickerIndexPath!.row - 1]
                targetedDatePicker.setDate(itemData[dateKey] as! Date, animated: false)
            }
        }
    }
    
    func hasPickerForIndexPath(indexPath: NSIndexPath) -> Bool {
        var hasDatePicker = false
        
        let targetedRow = indexPath.row + 1
        let checkDatePickerCell = tableView.cellForRow(at: IndexPath(row: targetedRow, section: 0))
        let checkDatePicker = checkDatePickerCell?.viewWithTag(datePickerTag)
        
        hasDatePicker = checkDatePicker != nil
        return hasDatePicker
    }
}
