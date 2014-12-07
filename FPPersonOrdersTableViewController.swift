//
//  FPPersonOrdersTableViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 11/25/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit

class FPPersonOrdersTableViewController: UITableViewController {
    
    var person:FPPerson?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var AddButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addOrder")
        //var doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
        navigationItem.rightBarButtonItem = AddButton
        //navigationItem.leftBarButtonItem = doneButton

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        var nib = UINib(nibName: "FPDutchOrderTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "dutchOrder")
        self.tableView.rowHeight = 50
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return (self.person?.orderList.count)!
    }
    
    func newOrder(orderName:String, orderPrice:String){
        println(orderName)
        println((orderPrice as NSString).doubleValue)
        
        self.person?.orderList.append(FPOrderObject(name:orderName,price:(orderPrice as NSString).doubleValue))
        //let parent = parentViewController as FPMainViewController
        //parent.peoples[(parent.path?.row)!].orderList.append(FPOrderObject(name:orderName,price:(orderPrice as NSString).doubleValue))

        self.tableView.reloadData()
    }
    

    @IBAction func addOrder(sender: AnyObject) {
           }
    
    func addOrder(){
        println("test bar button")
        var inputNameTextField:UITextField?
        var inputPriceTextField:UITextField?
        
        let alertController = UIAlertController(title: "Add New Order", message: "Enter order and order price", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Order"
            textField.keyboardType = .Default
            textField.autocapitalizationType = .Sentences
            inputNameTextField = textField
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Price"
            textField.keyboardType = .DecimalPad
            inputPriceTextField = textField
        }
        
        let okay = UIAlertAction(title: "Okay",
            style: UIAlertActionStyle.Default,
            //handler: {(alertController: UIAlertAction!) in (self.newOrder(ordername:(inputNameTextField?.text)!,orderPrice:(inputPriceTextField?.text)!))}
            handler: {(alertController: UIAlertAction!) in (self.newOrder((inputNameTextField?.text)!, orderPrice: (inputPriceTextField?.text)!))}
            
        )
        
        let cancel = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: {(alertController: UIAlertAction!) in ()}
        )
        
        alertController.addAction(okay)
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)


    }
    
    func done(segue:UIStoryboardSegue){
        
    }
    


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FPDutchOrderTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dutchOrder", forIndexPath: indexPath) as FPDutchOrderTableViewCell

        // Configure the cell...
        let order = self.person?.orderList[indexPath.row]
        
        cell.cellName.text = order?.orderName.uppercaseString
        cell.cellPrice.text = NSString(format: "%.2f", (order?.orderPrice)!)

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.person?.orderList.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

        // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if(segue.identifier == "saveOrders"){
            
            let vc = segue.destinationViewController as FPMainViewController
            let index = vc.path?.row
            vc.peoples[index!] = person!
            
        }
    }


}
