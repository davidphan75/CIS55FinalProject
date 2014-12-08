//
//  FPMainDebtViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 12/1/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit
import CoreData


class FPMainDebtViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIGestureRecognizerDelegate{
    
    
    @IBOutlet weak var lowerNavBar: UINavigationBar!
    @IBOutlet weak var debtCollectionView: UICollectionView!
    @IBOutlet weak var debtTableView: UITableView!
    var debtPicker = UIPickerView()
    var indexPath:NSIndexPath?
    var editIndexPath:NSIndexPath?
    var debtArray = [String]()
    let debtOptions:[String] = ["Owe","Owe's Me"]
    var inputDebtType:UITextField?
    var unwindImageData:NSData?
    var unwindString:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let data = NSKeyedArchiver.archivedDataWithRootObject(self.debtArray)
        
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
        var nib = UINib(nibName: "FPDebtPersonCollectionViewCell", bundle: nil)
        var nib2 = UINib(nibName: "FPDebtTableViewCell", bundle: nil)
        debtCollectionView?.registerNib(nib, forCellWithReuseIdentifier: "collectionCell")
        debtTableView?.registerNib(nib2, forCellReuseIdentifier: "debtTableCell")
        
        self.createPickerView()
        debtTableView.rowHeight = 50
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        //lowerNavBar.barStyle = UIBarStyle.Black
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "logo.png")
        imageView.image = image
        
        navigationItem.titleView = imageView
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        debtCollectionView.addGestureRecognizer(longPressGestureRecognizer)
        longPressGestureRecognizer.delegate = self
        
        let panUpGuester = UIPanGestureRecognizer(target: self, action: "panUpHandler:")
        debtCollectionView.addGestureRecognizer(panUpGuester)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addDebt(sender: AnyObject) {
        
        var inputNameField:UITextField?
        var inputDebtAmount:UITextField?

        
        let alertController = UIAlertController(title: "Add New Debt", message: "Enter debt, amount and type", preferredStyle: UIAlertControllerStyle.Alert)
        
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
    
    //Mark ------------------------------PickerViews
    
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
        
        let person = (fetchedResultsController.objectAtIndexPath(indexPath) as FPPersonDebt)
        var orientation: UIImageOrientation = .Up
        let cImage = CIImage(data: person.picture)
        let newImage = UIImage(CIImage: cImage, scale: 2, orientation: orientation)
        cell.cellPicture.image = newImage
        cell.cellPicture.layer.cornerRadius = cell.cellPicture.frame.size.width / 2
        cell.cellPicture.clipsToBounds = true
        if(indexPath == self.indexPath){
            cell.cellPicture.layer.opacity = 1
        }else{
            cell.cellPicture.layer.opacity = 0.65
        }
        cell.cellName.text = person.name.uppercaseString
        
        return cell
    }
    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println((fetchedResultsController.objectAtIndexPath(indexPath) as FPPersonDebt).name)
        let PersonDebt = (fetchedResultsController.objectAtIndexPath(indexPath) as FPPersonDebt)
        self.debtArray = (NSKeyedUnarchiver.unarchiveObjectWithData(PersonDebt.arrayData) as Array)
        

        //self.lowerNavBar.topItem?.title = "\(PersonDebt.name)'s Debts'"
        var barTitle = ""
        for char in PersonDebt.name{
            barTitle += " \(char)"
        }
        barTitle += " S   D E B T S"
        self.lowerNavBar.topItem?.title = barTitle.uppercaseString
        
        self.debtTableView.reloadData()
        if((self.indexPath) != nil){
            (collectionView.cellForItemAtIndexPath(self.indexPath!) as FPDebtPersonCollectionViewCell).cellPicture.layer.opacity = 0.65
        }
        println("after thing")
        println(indexPath)
        (collectionView.cellForItemAtIndexPath(indexPath) as FPDebtPersonCollectionViewCell).cellPicture.layer.opacity = 1
        self.indexPath = indexPath
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        debtCollectionView?.reloadData()
        debtTableView?.reloadData()
    }
    
    
    //Mark ----------------------Guesture Controlls
    
    
    func longPressHandler(sender:UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Began){
            var tapLocation:CGPoint = sender.locationInView(debtCollectionView)
            let indexPath = debtCollectionView.indexPathForItemAtPoint(tapLocation)
            println(indexPath?.row)
            if(indexPath != nil){
                self.editIndexPath = indexPath
                let context = fetchedResultsController.managedObjectContext
                //context.deleteObject(fetchedResultsController.objectAtIndexPath(indexPath!) as NSManagedObject)
                performSegueWithIdentifier("ChangeDebtPerson", sender: self)
            }
            
        }
    }
    
    func panUpHandler(sender:UIPanGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Began){
            var tapLocation:CGPoint = sender.locationInView(debtCollectionView)
            let indexPath = debtCollectionView.indexPathForItemAtPoint(tapLocation)
            println(indexPath?.row)
            println(indexPath)
            
            if(indexPath != nil){
                let context = fetchedResultsController.managedObjectContext
                context.deleteObject(fetchedResultsController.objectAtIndexPath(indexPath!) as NSManagedObject)
                self.debtArray = [String]()
                self.lowerNavBar.topItem?.title = ""
                self.indexPath = nil
                //self.debtTableView.reloadData()
                
            }
        }
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
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FPDebtTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("debtTableCell", forIndexPath: indexPath) as FPDebtTableViewCell
        
        // Configure the cell...
        //cell.textLabel?.text = (debtArray[indexPath.row])
        let fullString = debtArray[indexPath.row]
        var splitString = fullString.componentsSeparatedByString(" ")
        cell.cellName.text = splitString[1].uppercaseString
        cell.cellAmount.text = splitString[0]
        cell.cellAmount.textColor = UIColor.whiteColor()
        cell.cellAmount.layer.cornerRadius = cell.cellAmount.frame.size.height / 2
        cell.cellAmount.clipsToBounds = true
        if(Array(splitString[0])[0] == "-"){
            cell.cellAmount.backgroundColor = UIColor.grayColor()
        }else{
            cell.cellAmount.backgroundColor = UIColor.greenColor()
        }
         
        return cell
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
            
            //let context = fetchedResultsController.managedObjectContext
            //context.deleteObject(fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
            debtArray.removeAtIndex(indexPath.row)
            let data = NSKeyedArchiver.archivedDataWithRootObject(debtArray)
            let PersonDebt = (fetchedResultsController.objectAtIndexPath(self.indexPath!) as FPPersonDebt)
            PersonDebt.arrayData = data
            //tableView.reloadData()
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    func spaceOutWord(word:String)->String{
        var spacedWord:String = ""
        for thisChar in word{
            spacedWord += " \(thisChar)"
        }
        return spacedWord
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
        if(segue.identifier == "ChangeDebtPerson"){
            let vc = segue.destinationViewController as FPDebtAddPersonViewController
            vc.editingPerson = true
            vc.coreObject = (fetchedResultsController.objectAtIndexPath(editIndexPath!) as NSManagedObject)
        }
    }


    @IBAction func unwindSegue(segue:UIStoryboardSegue){
        println("unwind")
        let person = (fetchedResultsController.objectAtIndexPath(self.editIndexPath!) as FPPersonDebt)
        person.picture = unwindImageData!
        person.name = unwindString!
        viewDidLoad()
    }
}
