//
//  FPMainTableViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 11/22/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import Foundation
import UIKit

class FPMainTableViewController: UITableViewController {
    
    var peoples = [FPPerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return self.peoples.count
    }
    
    func addPerson(name:String){
        let parent = parentViewController as FPMainViewController
    
        peoples.append(FPPerson(personName: name))
        parent.peoples.append(FPPerson(personName: name))
        self.tableView.reloadData()
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("peopleCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = peoples[indexPath.row].name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let parent = parentViewController as FPMainViewController
        
        let parent = parentViewController as FPMainViewController
        parent.path = indexPath
        parent.performSegueWithIdentifier("showOrders", sender: self)
        println(self.peoples[indexPath.row].name)
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
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
    }
    

}
