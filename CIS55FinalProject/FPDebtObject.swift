//
//  FPDebtObject.swift
//  CIS55FinalProject
//
//  Created by David Phan on 12/4/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit

class FPDebtObject: NSObject {
    var amount:Double = 0.0
    var name:String = ""
    var owe:Bool = false
   
    
    convenience init(amount:Double, name:String, owe:Bool){
        self.init()
        self.name = name
        self.amount = amount
        self.owe = owe
        
    }
    
    func stringFormat()->String{
        var convertedString:String?
        if(self.owe == true){
            convertedString = "-\(self.amount) \(self.name)"
        }else{
            convertedString = "\(self.amount) \(self.name)"
        }
        return convertedString!
    }
}
