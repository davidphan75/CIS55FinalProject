//
//  FPDisplayBillViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 11/30/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit
import Foundation

class FPDisplayBillViewController: UIViewController {
    
    var peoples = [FPPerson]()
    var tax:Double?
    var tip:Double?
    var bill:String = ""
    @IBOutlet weak var BillTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createBill()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBill(){
        var partySubTotal:Double = 0.0
        var partyGrandTotal:Double = 0.0
        for person in peoples{
            bill += "\(person.name)\r"
            for order in person.orderList{
                bill += "\t\t\(order.orderName)" // \t\t\t\t\t \(order.orderPrice)\r"
                var numOfTabs:Int = 7 - (((order.orderName as NSString).length ) / 5)
                if(((order.orderName as NSString).length ) % 5 == 0){++numOfTabs}
                for var i = 0; i < numOfTabs; ++i{
                        self.bill += "\t"
                }
                bill += "\(formatDouble(order.orderPrice))\r"
            }
            let grandtotal = (person.Subtotal() * (1 + (tax!/100)))*(1 + (tip!/100))
            bill += "\t\t\t\t\t\t Subtotal:\t\t\(formatDouble(person.Subtotal()))\r"
            bill += "\t\t\t\t\t\t Grandtotal:   \t\(formatDouble(grandtotal))\r\r"
            partySubTotal += person.Subtotal()
            partyGrandTotal += grandtotal
        }
        
        bill += "\r\t\t\t\t\t PartySubtotal:   \t\(formatDouble(partySubTotal))\r"
        bill += "\t\t\t\t\t PartyGrandtotal:\t\(formatDouble(partyGrandTotal))\r"
        BillTextView.text = bill
    }
    
    func formatDouble(number:Double)->NSString{
        let formattedNumber = NSString(format: "%.2f",number)
        return formattedNumber
    }
    
    
    func countSpaces(word:String)->Int{
        var count = 0
        for char in word{
            if(char == " "){++count}
        }
        return count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
