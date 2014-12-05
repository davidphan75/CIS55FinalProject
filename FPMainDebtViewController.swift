//
//  FPMainDebtViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 12/1/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit
import CoreData


class FPMainDebtViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UIPickerViewDelegate{
    
    
    @IBOutlet weak var debtCollectionView: UICollectionView!
    @IBOutlet weak var debtTableView: UITableView!
    var debtPicker = UIPickerView()
    var indexPath:NSIndexPath?
    var debtArray = [String]()
    let debtOptions:[String] = ["Owe","Owe's Me"]
    var inputDebtType:UITextField?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let data = NSKeyedArchiver.archivedDataWithRootObject(self.debtArray)
        
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
        var nib = UINib(nibName: "FPDebtPersonCollectionViewCell", bundle: nil)
        debtCollectionView?.registerNib(nib, forCellWithReuseIdentifier: "collectionCell")
        
        self.createPickerView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addDebt(sender: AnyObject) {
        
        var inputNameField:UITextField?
        var inputDebtAmount:UITextField?

        
        let alertController = UIAlertController(title: "Add New Person", message: "What is the persons name", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
            textField.keyboardType = .Default
            textField.autocapitalizationType = .Words
            inputNameField = textField
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .DecimalPad
            textField.autocapitalizationType = .Words
            inputDebtAmount = textField
        }

        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Debt type"
            //textField.keyboardType = .DecimalPad
            textField.inputView = self.debtPicker
            //textField.inputAccessoryView = self.too
            self.inputDebtType = textField
        }

        
        let okay = UIAlertAction(title: "Okay",
            style: UIAlertActionStyle.Default,
            handler: {(alertController: UIAlertAction!) in (self.addDebt((inputNameField?.text)!,amount: (inputDebtAmount?.text)!,debt: (self.inputDebtType?.text)!))}
        )
        
        let cancel = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: {(alertController: UIAlertAction!) in ()}
        )
        
        alertController.addAction(okay)
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addDebt(name:String, amount:String, debt:String){
        
        println(debt)
        
        if(debt == "Owe"){
            debtArray.append("-\(amount) \(name)")
        }else{
            debtArray.append("\(amount) \(name)")
        }
        
        let PersonDebt = (fetchedResultsController.objectAtIndexPath(indexPath!) as FPPersonDebt)
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.debtArray)
        PersonDebt.arrayData = data
        self.debtTableView.reloadData()

    }
    
    func createPickerView(){
        
        debtPicker.delegate = self
        debtPicker.showsSelectionIndicator = true
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return debtOptions.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String {
        return debtOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       self.inputDebtType?.text = self.debtOptions[row]
    }

    
    // MARK: ------------------------ UICollectionViewDataSource
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
        
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> FPDebtPersonCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as FPDebtPersonCollectionViewCell
        
        // Configure the cell
        
        var orientation: UIImageOrientation = .Up
        let cImage = CIImage(data: (fetchedResultsController.objectAtIndexPath(indexPath) as FPPersonDebt).picture)
        let newImage = UIImage(CIImage: cImage, scale: 2, orientation: orientation)
        cell.cellPicture.image = newImage
        
        return cell
    }
    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println((fetchedResultsController.objectAtIndexPath(indexPath) as FPPersonDebt).name)
        let PersonDebt = (fetchedResultsController.objectAtIndexPath(indexPath) as FPPersonDebt)
        self.debtArray = (NSKeyedUnarchiver.unarchiveObjectWithData(PersonDebt.arrayData) as Array)
        self.indexPath = indexPath
        self.debtTableView.reloadData()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        debtCollectionView?.reloadData()
    }
    
    // MARK: -------------------- Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
            println(debtArray.count)
            return debtArray.count
        
        
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = (debtArray[indexPath.row])
         
        return cell
    }
    
    
    
    //-----------------------------Core Data
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }else {
            return nil
        }
        }()
    
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: TDCoreObjectFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func TDCoreObjectFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "FPPersonDebt")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


    @IBAction func unwindSegue(segue:UIStoryboardSegue){
        println("unwind")
    }
}
