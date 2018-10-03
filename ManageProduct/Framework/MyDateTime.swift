//
//  MyDateTime.swift
//  ManageProduct
//
//  Created by NXA on 9/30/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import Foundation

public class MyDateTime {
    
    public init() {}
    
    /* Date Time */
    
    public static func convertDateToString(date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let myString = formatter.string(from: date)
        return myString
    }
    
    public static func convertStringToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: string)
        return date
    }
    
    public static func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    /* Format Number */
    
    public static func addCommaNumber(string: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSize = 3
        let formattedNumber = numberFormatter.string(from: NSNumber(value: Double(string)!))
        return formattedNumber
    }
    
    public static func removeCommaNumber(string: String) -> String? {
        return string.replacingOccurrences(of: ",", with: "")
    }
    
    public static func formatCurrency(string: String) -> String? {
        let price = Int(string)
        let curFormatter : NumberFormatter = NumberFormatter()
        curFormatter.numberStyle = .currency
        curFormatter.currencyCode = "USD"
        curFormatter.maximumFractionDigits = 0
        let total = curFormatter.string(from: price! as NSNumber)
        return total
    }
    
}
