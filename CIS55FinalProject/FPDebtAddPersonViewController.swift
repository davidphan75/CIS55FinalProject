//
//  FPDebtAddPersonViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 12/1/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit
import MobileCoreServices
import Foundation
import CoreData

class FPDebtAddPersonViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var naviItem: UINavigationItem!
    //@IBOutlet weak var naviBar: UINavigationBar!
    var cameraUI:UIImagePickerController = UIImagePickerController()
    var editingPerson:Bool = false
    var coreObject:NSManagedObject?
    
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
        fetchedResultsController = NSFetchedResultsController(fetchRequest: FPCoreObjectFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func FPCoreObjectFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "FPPersonDebt")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }



    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("reaches add screen")
        // Do any additional setup after loading the view.
        //var nav = self.navigationController?.navigationBar
        
        naviBar.barStyle = UIBarStyle.Black
        //nav?.tintColor = UIColor.yellowColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "logo.png")
        imageView.image = image
    
        naviItem.titleView = imageView
        
        if(editingPerson){
            let person = (coreObject as FPPersonDebt)
            let picture = UIImage(data: person.picture)
            self.picture.image = picture
            self.nameInput.text = person.name
        }
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
    
    //Mark: - Image Picker 
    
    @IBAction func savePerson(sender: AnyObject) {
        let imageData = UIImagePNGRepresentation(self.picture.image)
        if(editingPerson){
            self.performSegueWithIdentifier("savePerson", sender: self)
        }else{
            var array = [String]()
            let arrayData = NSKeyedArchiver.archivedDataWithRootObject(array)
            FPPersonDebt.createInManagedObjectContext(self.managedObjectContext!, arrayData: arrayData, name: self.nameInput.text, picture: imageData)
        }
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func choosePicture(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Upload Image", message: "Where would you like to get picture from ?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let option0 = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.presentCamera())})
        let option1 = UIAlertAction(title: "Open Camera Roll", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.presentCameraRoll())})
        let option3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in ()})
        
        
        actionSheet.addAction(option0)
        actionSheet.addAction(option1)
        actionSheet.addAction(option3)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera()
    {
    cameraUI = UIImagePickerController()
    cameraUI.delegate = self
    cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
    cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
    cameraUI.allowsEditing = true
    
    self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func presentCameraRoll()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = true
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        //    var mediaType:NSString = info.objectForKey(UIImagePickerControllerEditedImage) as NSString
        var imageToSave:UIImage
        
        imageToSave = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        
        //UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        picture.image = imageToSave
        self.dismissViewControllerAnimated(true, completion: nil)
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "savePerson"){
            let vc = segue.destinationViewController as FPMainDebtViewController
            println(vc.editIndexPath!)
            //(vc.fetchedResultsController.objectAtIndexPath(vc.editIndexPath!) as FPPersonDebt).name = self.nameInput.text
            vc.unwindImageData = UIImagePNGRepresentation(self.picture.image)
            vc.unwindString = self.nameInput.text
            
        }
    }
    

}
