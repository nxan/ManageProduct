//
//  MyCoreData.swift
//  ManageProduct
//
//  Created by NXA on 10/1/18.
//  Copyright © 2018 NXA. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class MyCoreData {
    
    public init() {}
    
    public static func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    public static func saveItem() {
        do {
            try getContext().save()
            print("Saved")
        } catch {
            print("Save Error")
        }
    }
    
    public static func loadItem(array: [Product]) {
        var arrayItem = array
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        do {
           arrayItem = try getContext().fetch(fetchRequest)
        } catch {
            print("Load data error \(arrayItem)")
        }
    }
    
     
    
    public static func removeItem(id: String) {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = '\(id)'", getContext())
        let fetchResult = try! getContext().fetch(fetchRequest)
        for result in fetchResult {
            getContext().delete(result as NSManagedObject)
        }        
    }
    
    public static func loadDataByAttribute(array: [Product], attribute: String, string: String) {
        var arrayItem = array
        do {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "\(attribute) == %@", string)
            let fetchResult = try getContext().fetch(fetchRequest)
            for result in fetchResult {
                arrayItem.append(result)
            }
        } catch {
            print("Load data error \(arrayItem)")
        }
    }
    
    public static func getAttribute(attribute: String) -> [String] {
        var arrayDate = [String]()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Product", in: getContext())
        let fetchRequest = NSFetchRequest<NSDictionary>()
        fetchRequest.entity = entityDescription
        fetchRequest.includesPropertyValues = true
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = ["\(attribute)"]
        fetchRequest.resultType = .dictionaryResultType
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for result in fetchResult {
                if(!arrayDate.contains(MyDateTime.convertDateToString(date: result["\(attribute)"]! as! Date)!)) {
                    arrayDate.append(MyDateTime.convertDateToString(date: result["\(attribute)"]! as! Date)!)
                }
            }
        } catch {
            print("Load Data Error \(arrayDate)")
        }
        return arrayDate
    }
   
}
