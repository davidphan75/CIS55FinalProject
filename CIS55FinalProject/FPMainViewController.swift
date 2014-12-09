//
//  FPMainViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 11/22/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import Foundation
import UIKit

class FPMainViewController: UIViewController, UITableViewDelegate, UIGestureRecognizerDelegate{

    var path:NSIndexPath?
    var peoples = [FPPerson]()
    @IBOutlet weak var taxInput: UITextField!
    @IBOutlet weak var tipInput: UITextField!
    @IBOutlet weak var personTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var nib = UINib(nibName: "FPDutchPersonTableViewCell", bundle: nil)
        self.personTableView.registerNib(nib, forCellReuseIdentifier: "dutchPersonCell")
        self.personTableView.rowHeight = 50
        
        var nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.Black
        //nav?.tintColor = UIColor.yellowColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "logo.png")
        imageView.image = image
        
        navigationItem.titleView = imageView
        
        let panUpGuester = UIPanGestureRecognizer(target: self, action: "panUpHandler:")
        self.view.addGestureRecognizer(panUpGuester)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        self.personTableView.addGestureRecognizer(longPressGesture)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewDidAppear(animated: Bool) {
        
    }
    */
    
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
    
    
    //Mark ----------------------Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return peoples.count
    }
    
    func addPerson(name:String){
        //let parent = parentViewController as FPMainViewController
        
        peoples.append(FPPerson(personName: name))
        self.personTableView.reloadData()
        //parent.peoples.append(FPPerson(personName: name))
        //self.personTableView.reloadData()
    }
    
    @IBAction func addButton(sender: AnyObject) {
        
        
        var inputTextField:UITextField?
        
        let alertController = UIAlertController(title: "Add New Person", message: "What is the persons name", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
            textField.keyboardType = .Default
            textField.autocapitalizationType = .Words
            inputTextField = textField
        }
        
        let okay = UIAlertAction(title: "Okay",
            style: UIAlertActionStyle.Default,
            handler: {(alertController: UIAlertAction!) in (self.addPerson((inputTextField?.text)!))}
        )
        
        let cancel = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: {(alertController: UIAlertAction!) in ()}
        )
        
        alertController.addAction(okay)
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FPDutchPersonTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dutchPersonCell", forIndexPath: indexPath) as FPDutchPersonTableViewCell
        
        // Configure the cell...
        cell.cellName.text = peoples[indexPath.row].name.uppercaseString
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let parent = parentViewController as FPMainViewController
        
        //let parent = parentViewController as FPMainViewController
        //parent.path = indexPath
        //parent.performSegueWithIdentifier("showOrders", sender: self)
        //println(self.peoples[indexPath.row].name)
        self.path = indexPath
        performSegueWithIdentifier("showOrders", sender: self)

    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.peoples.removeAtIndex(indexPath.row)
            tableView.reloadData()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    //Mark -------------------Gesture Controls
    
    func panUpHandler(sender:UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Began){
            self.tipInput.resignFirstResponder()
            self.taxInput.resignFirstResponder()
        }
    }
    
    func longPressHandler(sender:UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Began){
            var tapLocation:CGPoint = sender.locationInView(self.personTableView)
            let indexPath = self.personTableView.indexPathForRowAtPoint(tapLocation)
            println(indexPath?.row)
            println(indexPath)
            
            if(indexPath != nil){
                self.deletePerson(indexPath!)
            }
        }
    }
    
    func deletePerson(indexPath:NSIndexPath){
        let actionSheet = UIAlertController(title: "Delete Person", message: "Delete person and all of their orders?", preferredStyle: UIAlertControllerStyle.ActionSheet)
    let option1 = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {(actionSheet: UIAlertAction!) in (self.deletePerson(indexPath))})
        let option3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in ()})
        
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option3)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }




    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showOrders"){
            let vc = segue.destinationViewController as FPPersonOrdersTableViewController
            //vc.tabBarItem.title = self.peoples[(path?.row)!].name
            vc.titleString = "\(self.peoples[(path?.row)!].name)s orders"
            vc.person = self.peoples[(path?.row)!]
        }else if(segue.identifier == "showBill"){
            let vc = segue.destinationViewController as FPDisplayBillViewController
            vc.peoples = self.peoples
            vc.tax = (self.taxInput.text as NSString).doubleValue
            vc.tip = (self.tipInput.text as NSString).doubleValue
        }
    }
    

}
