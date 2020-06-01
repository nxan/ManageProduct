//
//  MyDate.swift
//  ManageProduct
//
//  Created by NXA on 9/30/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import Foundation

public class MyDateTime {
    
    public init() {}
    
    public func convertDateToString(date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let myString = formatter.string(from: date)
        return myString
    }
    
}
