//
//  FPMainViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 11/22/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import Foundation
import UIKit

class FPMainViewController: UIViewController {

    var path:NSIndexPath?
    var peoples = [FPPerson]()
    @IBOutlet weak var taxInput: UITextField!
    @IBOutlet weak var tipInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "logo.png")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        taxInput.resignFirstResponder()
        tipInput.resignFirstResponder()
    }

    
    @IBAction func unwindSegue(segue:UIStoryboardSegue){
        println("unwind")
    }
    
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showOrders"){
            let vc = segue.destinationViewController as FPPersonOrdersTableViewController
            //vc.tabBarItem.title = self.peoples[(path?.row)!].name
            vc.navigationItem.title = "\(self.peoples[(path?.row)!].name)'s orders"
            vc.person = self.peoples[(path?.row)!]
        }else if(segue.identifier == "showBill"){
            let vc = segue.destinationViewController as FPDisplayBillViewController
            vc.peoples = self.peoples
            vc.tax = (self.taxInput.text as NSString).doubleValue
            vc.tip = (self.tipInput.text as NSString).doubleValue
        }
    }
    

}
