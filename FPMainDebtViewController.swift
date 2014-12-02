//
//  FPMainDebtViewController.swift
//  CIS55FinalProject
//
//  Created by David Phan on 12/1/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit
import CoreData


class FPMainDebtViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
