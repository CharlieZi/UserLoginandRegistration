//
//  ListTableViewController.swift
//  BmobSync
//
//  Created by HuCharlie on 4/24/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit




class WatchListTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    var WatchLiestData:NSMutableArray = NSMutableArray()
    var lastsyncStamp:NSDate = NSDate()
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // swreveal gesture setup
        SlideMenuBtn.target = self.revealViewController()
        SlideMenuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    func loadData(){
        
        WatchLiestData.removeAllObjects()
        
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        
        
        
        var watchquery:BmobQuery = BmobQuery(className: "Company_News")
        var currentUser:BmobUser = BmobUser.getCurrentObject()
        
        
        
        watchquery.whereObjectKey("watch", relatedTo:currentUser )
        watchquery.orderByDescending("createdAt")
        
        watchquery.countObjectsInBackgroundWithBlock { (watchNum, error:NSError!) -> Void in
            
        }
        
        
        
        watchquery.findObjectsInBackgroundWithBlock { (objects, error:NSError!) -> Void in
            if error != nil{
                println("error")
            }else{
                for object in objects {
                    let watchedNews:BmobObject = object as! BmobObject
                    let itemDict:NSDictionary = ["identifier":watchedNews.objectId]
                    println(watchedNews.objectId)
                    self.WatchLiestData.addObject(itemDict)
                    println(self.WatchLiestData.count)
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return WatchLiestData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:WatchListTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! WatchListTableViewCell
        
        
        // UI setup
        cell.newsAuthor.alpha = 0
        cell.newsTimestamp.alpha = 0
        cell.newsTitle.alpha = 0
        cell.newsContent.alpha = 0
        
        cell.CellUIView.alpha = 0
        
        cell.CellUIView.layer.cornerRadius = 0.0
        cell.CellUIView.layer.masksToBounds = false
        cell.CellUIView.layer.shadowColor = UIColor.blackColor().CGColor
        cell.CellUIView.layer.shadowOffset = CGSize(width: 0, height: 1);
        cell.CellUIView.layer.shadowOpacity = 0.0
        
        
        //configure cell data
        
        let itemDict:NSDictionary = WatchLiestData.objectAtIndex(indexPath.row) as! NSDictionary
        let identifier:String = itemDict.objectForKey("identifier")as! String
        
        var dateFormattor:NSDateFormatter = NSDateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let predicate:NSPredicate = NSPredicate(format: "identifier == '\(identifier)'")
        let results:NSArray = SwiftCoreDataHelper.fetchEntitiesForClass(NSStringFromClass(News), withPredicate: predicate, inManagedObjectContext: moc)
        
        if results.count > 0 {
            
            let localLoadNews:News = results.lastObject as! News
            
            cell.newsAuthor.text = localLoadNews.author
            cell.newsTimestamp.text = dateFormattor.stringFromDate(localLoadNews.timestamp)
            cell.newsTitle.text = "myNewsTitle"
            cell.newsContent.text = localLoadNews.content
            
        }else{
            let getnews:BmobQuery = BmobQuery(className: "Company_News")
            getnews.getObjectInBackgroundWithId(itemDict.objectForKey("identifier")as! String, block: { (singleNews:BmobObject!, error:NSError!) -> Void in
                if error != nil {
                    println("error")
                }else{
                    // get author
                    let findauthor:BmobQuery = BmobUser.query()
                    let author:String = String()
                    findauthor.getObjectInBackgroundWithId(singleNews.objectForKey("Company")as! String, block: { (newsAuthor, error:NSError!) -> Void in
                        let author = newsAuthor.objectForKey("username")as! String
                    })
                    // get content
                    let content:String = singleNews.objectForKey("Content")as! String
                    // get timestamp
                    let timestamp:NSDate = singleNews.createdAt
               
                    
                    cell.newsContent.text = content
                    cell.newsAuthor.text = author
                    cell.newsTimestamp.text = dateFormattor.stringFromDate(timestamp)
                }
            })
        }
        

        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.newsAuthor.alpha = 1
            cell.newsTimestamp.alpha = 1
            cell.newsTitle.alpha = 1
            cell.newsContent.alpha = 1
            
            cell.CellUIView.alpha = 1
            
            cell.CellUIView.layer.cornerRadius = 0.5
            cell.CellUIView.layer.masksToBounds = false
            cell.CellUIView.layer.shadowColor = UIColor.blackColor().CGColor
            cell.CellUIView.layer.shadowOffset = CGSize(width: 0, height: 3);
            cell.CellUIView.layer.shadowOpacity = 0.5
            
            
        })
        
        
        
        
        return cell
    }
    
    
    
    
    
    @IBAction func refreshBtnClicked(sender: AnyObject) {
        loadData()
        self.tableView.reloadData()
        
    }
    
}
