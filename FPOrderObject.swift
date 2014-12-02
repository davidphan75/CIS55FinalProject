//
//  FPOrderObject.swift
//  CIS55FinalProject
//
//  Created by David Phan on 11/24/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit

class FPOrderObject: NSObject {
    
    var orderName:String = ""
    var orderPrice:Double = 0.0
    
    convenience init(name:String,price:Double) {
        self.init()
        self.orderName = name
        self.orderPrice = price

    }

    func priceWithTax(tax:Double)->Double{
        return (self.orderPrice * (1 + (tax/100)))
    }
    
    func priceWithTip(tip:Double)->Double{
        return (self.orderPrice * (1 + (tip/100)))
    }

}
