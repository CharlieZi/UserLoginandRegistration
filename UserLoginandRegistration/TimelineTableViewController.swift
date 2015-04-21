//
//  TimelineTableViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/21/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit
import Foundation

class TimelineTableViewController: UITableViewController {

    
    
    
    
    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    
    
    
    var timeLineData:NSMutableArray = NSMutableArray()
    
    func loadData(){
        timeLineData.removeAllObjects()
        var findTimelineData:BmobQuery = BmobQuery(className: "Company_News")
        
        findTimelineData.findObjectsInBackgroundWithBlock {
            (objects, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    self.timeLineData.addObject(object)
                }
                
                let array:NSArray = self.timeLineData.reverseObjectEnumerator().allObjects
                self.timeLineData = NSMutableArray(array: array)
                
                self.tableView.reloadData()
                println("recieve data successful!")
            }else{
                println("recieve data failed!")
            }

            
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        self.loadData()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        // SWreveal return button
        SlideMenuBtn.target = self.revealViewController()
        SlideMenuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 
        

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
        return timeLineData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TimelineTableViewCell = tableView.dequeueReusableCellWithIdentifier("companyNews", forIndexPath: indexPath) as! TimelineTableViewCell

        // Configure the cell...
        
        cell.companyNewsContent.alpha = 0
        cell.companyTimeStamp.alpha = 0
        cell.companyUser.alpha = 0
        
        let companyNews:BmobObject = self.timeLineData.objectAtIndex(indexPath.row) as! BmobObject
        
        cell.companyNewsContent.text = companyNews.objectForKey("Content") as! String
        
        
        
        //label time stamp
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm"
        cell.companyTimeStamp.text = dateFormatter.stringFromDate(companyNews.createdAt)

        
        //label company name
        
        
        
        var findCompany:BmobQuery = BmobUser.query()
        findCompany.whereKey("objectID" , equalTo:companyNews.objectForKey("Company").objectID)
        
        findCompany.findObjectsInBackgroundWithBlock { (objects, error:NSError!) -> Void in
            if error == nil {
                let user:BmobUser = (objects as NSArray).lastObject as! BmobUser
                cell.companyUser.text = user.objectForKey("username") as? String
                
                //animation
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    cell.companyNewsContent.alpha = 1
                    cell.companyTimeStamp.alpha = 1
                    cell.companyUser.alpha = 1
                })
            }else{
                println("print user query failed")
            }
        }
        
        
        
        

        
        
        
   
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
