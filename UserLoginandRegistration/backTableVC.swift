//
//  backTableVC.swift
//  slideOutMenu
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import Foundation


class backTableVC: UITableViewController {

    
    var TableArray = [String]()
    
    override func viewDidLoad() {
        TableArray = ["My Account","News","Watch List","Contact Us","QR Code"]
    }
    
    
  
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
    
    
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        var DestVC = segue.destinationViewController as! ViewController
//        
//        var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow()!
//        
//        
//        DestVC.varView = indexPath.row
//        
//    }


}