//
//  DivideTableViewController.swift
//  CIS55FinalProject
//
//  Created by Jenny Kwok on 12/2/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit

class DivideTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var BillTotalText: UITextField!
    @IBOutlet weak var TipText: UITextField!
    @IBOutlet weak var NumberPeopleText: UITextField!
    
    @IBOutlet weak var BillTotalLabel: UILabel!
    @IBOutlet weak var TipLabel: UILabel!
    @IBOutlet weak var PeopleLabel: UILabel!
    @IBOutlet weak var TipTotalLabel: UILabel!
    @IBOutlet weak var BillPerPersonLabel: UILabel!
    
    
    
    func calculation(){
        var billTotal = BillTotalText.text
        var tip = TipText.text
        var numPeople = NumberPeopleText.text
        if (numPeople == "" && billTotal == "" && tip == ""){
            numPeople = "1"
        }
        
        var billPer = ((billTotal as NSString).doubleValue * (1 + ((tip as NSString).doubleValue/100))) / ((numPeople as NSString).doubleValue)
    
        var tipTotal = (billTotal as NSString).doubleValue * ((tip as NSString).doubleValue/100)
        
        
        //label output
        
        BillTotalLabel.text = NSString(format: "The bill total is $%.2f.", (billTotal as NSString).doubleValue);
        TipLabel.text = NSString(format: "The percent of tip is \(tip)%%.");
        PeopleLabel.text = NSString(format: "The number of people is \(numPeople).");
        TipTotalLabel.text = NSString(format: "The tip is $%.2f.", tipTotal);
        BillPerPersonLabel.text = NSString(format: "The bill per person is $%.2f.", billPer);

        
        //reset text fields
        
        BillTotalText.text = ""
        TipText.text = ""
        NumberPeopleText.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "logo.png")
        imageView.image = image
        
        navigationItem.titleView = imageView

        
        let panUpGuester = UIPanGestureRecognizer(target: self, action: "panUpHandler:")
        self.view.addGestureRecognizer(panUpGuester)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }



    
    @IBAction func CalculationButton(sender: AnyObject) {
        calculation()
    }
    
    
    //Mark -------------------Gesture Controls
    
    func panUpHandler(sender:UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Began){
            self.BillTotalText.resignFirstResponder()
            self.NumberPeopleText.resignFirstResponder()
            self.TipText.resignFirstResponder()
        }
    }
    
    

  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
