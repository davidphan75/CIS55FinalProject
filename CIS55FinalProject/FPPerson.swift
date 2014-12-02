//
//  FPPerson.swift
//  CIS55FinalProject
//
//  Created by David Phan on 11/22/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit

class FPPerson: NSObject {
    
    var name:String = ""
    //var subtotal:Double = 0.0
    //var grandTotal:Double = 0.0
    var orderList = [FPOrderObject]()
    
    convenience init(personName:String){
        self.init()
        self.name = personName
    }
    
    func Subtotal()->Double{
        var sum:Double = 0.0
        for order in orderList{
            sum += order.orderPrice
        }
        return sum
    }
   
}
