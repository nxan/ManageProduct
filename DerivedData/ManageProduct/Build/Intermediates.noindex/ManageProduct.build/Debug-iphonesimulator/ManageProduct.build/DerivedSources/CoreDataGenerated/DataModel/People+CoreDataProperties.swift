//
//  People+CoreDataProperties.swift
//  
//
//  Created by NXA on 9/30/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var bankCode: String?
    @NSManaged public var bankLocation: String?
    @NSManaged public var card: String?
    @NSManaged public var cardDate: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var product: String?
    @NSManaged public var type: String?

}
