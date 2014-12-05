//
//  FPPersonDebt.swift
//  CIS55FinalProject
//
//  Created by David Phan on 12/1/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import Foundation
import CoreData

class FPPersonDebt: NSManagedObject {

    @NSManaged var picture: NSData
    @NSManaged var name: String
    @NSManaged var arrayData: NSData
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, arrayData:NSData, name:String, picture:NSData) -> FPPersonDebt {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("FPPersonDebt", inManagedObjectContext: moc) as FPPersonDebt
        
        newItem.arrayData = arrayData
        newItem.name = name
        newItem.picture = picture
      
        
        return newItem
    }

}
 