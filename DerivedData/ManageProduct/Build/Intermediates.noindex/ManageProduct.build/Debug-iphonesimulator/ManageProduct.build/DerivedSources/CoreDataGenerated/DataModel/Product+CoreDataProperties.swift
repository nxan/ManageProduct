//
//  Product+CoreDataProperties.swift
//  
//
//  Created by NXA on 9/30/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var money: Double
    @NSManaged public var note: String?
    @NSManaged public var peopleType: String?
    @NSManaged public var productName: String?
    @NSManaged public var type: String?
    @NSManaged public var unit: Double
    @NSManaged public var weight: Double

}
