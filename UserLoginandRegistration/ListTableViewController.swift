//
//  ListTableViewController.swift
//  BmobSync
//
//  Created by HuCharlie on 4/24/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit







class ListTableViewController: UITableViewController {
    
    
    @IBOutlet var NewsTableView: UITableView!
    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    var NewsTimelineData:NSMutableArray = NSMutableArray()
    var lastsyncStamp:NSDate = NSDate()
    
    
    
    
    // life cycle start
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshControl = refreshControl
        
        SlideMenuBtn.target = self.revealViewController()
        SlideMenuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // life cycle end
    


    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return NewsTimelineData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ListTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListTableViewCell

        //---Configure the cell
        cell.cardView.profileImageView.image = UIImage(named: "dummy")
        cell.cardView.addShadow()
        cell.newsAuthor.alpha = 0
        cell.newsTimestamp.alpha = 0
        cell.newsContent.alpha = 0
        cell.CellUIView.alpha = 0
        
        
        //---date operation
        var dateFormattor:NSDateFormatter = NSDateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd hh:mm:ss"
        //---Variable Defination
        let itemDict:NSDictionary = NewsTimelineData.objectAtIndex(indexPath.row) as! NSDictionary
        let identifier:String = itemDict.objectForKey("identifier")as! String
        //---Coredata Fetch
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let predicate:NSPredicate = NSPredicate(format: "identifier == '\(identifier)'")
        let results:NSArray = SwiftCoreDataHelper.fetchEntitiesForClass(NSStringFromClass(News), withPredicate: predicate, inManagedObjectContext: moc)
        
        if results.count > 0 {
            
            let localLoadNews:News = results.lastObject as! News
            
            cell.cardView.profileImageView.image = UIImage(data: localLoadNews.profileImage)
            cell.cardView.titleLabel.text = localLoadNews.author
            cell.cardView.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 10)
            cell.newsAuthor.text = localLoadNews.author
            cell.newsTimestamp.text = dateFormattor.stringFromDate(localLoadNews.timestamp)
            cell.newsContent.text = localLoadNews.content
            
        }else{
            BmobCoreDataHelper.LoadBmobDataNotInCoredata("Company_News", itemDict: itemDict, block: { (profileImage, author, content) -> Void in
                cell.cardView.profileImageView.image = profileImage
                cell.cardView.titleLabel.text = author
                cell.cardView.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 10)
                cell.newsAuthor.text = author
                cell.newsTimestamp.text = dateFormattor.stringFromDate(itemDict.objectForKey("timestamp")as! NSDate)
                cell.newsContent.text = content

            })
        }
        
        //---animation
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.newsAuthor.alpha = 1
            cell.newsTimestamp.alpha = 1
            cell.newsContent.alpha = 1
            cell.CellUIView.alpha = 1
            })
        
        //---like func
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: "likeNews:", forControlEvents: UIControlEvents.TouchUpInside)
        var likequery:BmobQuery = BmobQuery.queryForUser()
        var currentNews:BmobObject = BmobObject(withoutDatatWithClassName: "Company_News", objectId: itemDict.objectForKey("identifier")as! String)
        likequery.whereObjectKey("like", relatedTo:currentNews )
        likequery.countObjectsInBackgroundWithBlock { (likeNum, error:NSError!) -> Void in
            cell.likeCounter.text = toString(likeNum)
        }
        
        //---fin
        
        let tapGestureProfile:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "profilePhotoTap:")as UITapGestureRecognizer
        tapGestureProfile.view?.tag = indexPath.row
        
        cell.cardView.profileImageView.addGestureRecognizer(tapGestureProfile)

        
        
        
     
        
        return cell
        
        
    }
    

}



extension ListTableViewController {
    
    // buttons
    
    @IBAction func refreshBtnClicked(sender: AnyObject) {
        
        
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let resultstoDelete:NSArray = SwiftCoreDataHelper.fetchEntitiesForClass(NSStringFromClass(News), withPredicate: nil, inManagedObjectContext: moc)
        
        for item in resultstoDelete {
            let singleitemtoDelete:News = item as! News
            
            singleitemtoDelete.managedObjectContext?.deleteObject(singleitemtoDelete)
            SwiftCoreDataHelper.saveManagedObjectContext(moc)
        }
        
        loadData()
        self.tableView.reloadData()
        
    }

    
}  // buttons

extension ListTableViewController {
    
    // functions
    
    
    func likeNews(sender:UIButton){
        
        if BmobProfileImageHelper.userDidExist() {
            var likeRelation:BmobRelation = BmobRelation()
            var watchRelation:BmobRelation = BmobRelation()
            
            let currentUser:BmobUser = BmobUser.getCurrentUser() as BmobUser
            let itemDict:NSDictionary = NewsTimelineData.objectAtIndex(sender.tag)as! NSDictionary
            
            let findObject:BmobQuery = BmobQuery(className: "Company_News")
            findObject.getObjectInBackgroundWithId(itemDict.objectForKey("identifier")as! String, block: { (likeObject:BmobObject!, error:NSError!) -> Void in
                likeObject.addRelation(likeRelation, forKey: "like")
                likeRelation.addObject(currentUser)
                
                
                currentUser.addRelation(watchRelation, forKey: "watch")
                watchRelation.addObject(likeObject)
                
                likeObject.updateInBackground()
                currentUser.updateInBackground()
                self.tableView.reloadData()
            })

        }else{
            
            println("not login yet")
            
        }
        
    }
    
    func refreshData(){
        //load bmob online data
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let results:NSArray = SwiftCoreDataHelper.fetchEntitiesForClass(NSStringFromClass(News), withPredicate: nil, inManagedObjectContext: moc)
        
        
        for item in results {
            let singleNews = item as! News
            let timestamp:NSDate = singleNews.timestamp as NSDate
            lastsyncStamp = lastsyncStamp.laterDate(timestamp)
        }
        
        
        var findNewsAuthor:BmobQuery = BmobQuery(className: "Company_News")
        
        var findTimelineData:BmobQuery = BmobQuery(className: "Company_News")
        findTimelineData.findObjectsInBackgroundWithBlock {
            (objects, error:NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    
                    let downloadNews:BmobObject = object as! BmobObject
                    let timestamp:NSDate = downloadNews.createdAt as NSDate
                    
                    // find new added news
                    var dateFormattor:NSDateFormatter = NSDateFormatter()
                    dateFormattor.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    
                    
                    if (self.lastsyncStamp.compare(timestamp) == NSComparisonResult.OrderedAscending){
                        
                        
                        
                        var addNews:News = SwiftCoreDataHelper.insertManagedObjectOfClass(NSStringFromClass(News), inManagedObjectContext: moc) as! News
                        
                        let identifier:String = downloadNews.objectId as String
                        let content:String = downloadNews.objectForKey("Content") as! String
                        
                        var author:String = String()
                        
                        var findUserName:BmobQuery = BmobUser.query()
                        findUserName.whereKey("objectID" , equalTo:downloadNews.objectForKey("Company").objectID)
                        
                        findUserName.findObjectsInBackgroundWithBlock { (objects, error:NSError!) -> Void in
                            if error == nil {
                                let user:BmobUser = (objects as NSArray).lastObject as! BmobUser
                                author = user.objectForKey("username") as! String
                                addNews.author = author
                                addNews.identifier = identifier
                                addNews.content = content
                                addNews.timestamp = timestamp
                                
                                
                                SwiftCoreDataHelper.saveManagedObjectContext(moc)
                                
                                let newsDict:NSDictionary = ["identifier":identifier,"timestamp":timestamp,"content":content,"author":author]
                                
                                self.NewsTimelineData.addObject(newsDict)
                                let dateDescriptor:NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                                var sortedArray:NSArray = self.NewsTimelineData.sortedArrayUsingDescriptors([dateDescriptor])
                                
                                self.NewsTimelineData = NSMutableArray(array: sortedArray)
                                
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
        
    }
    
    func loadData(){
        
        NewsTimelineData.removeAllObjects()
        lastsyncStamp = NSDate.distantPast() as! NSDate
        
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let results:NSArray = SwiftCoreDataHelper.fetchEntitiesForClass(NSStringFromClass(News), withPredicate: nil, inManagedObjectContext: moc)
        
        
        //load local data and initialization
        
        if results.count > 0 {
            for item in results {
                let singleNews = item as! News
                let timestamp:NSDate = singleNews.timestamp as NSDate
                
                let newsDict:NSDictionary = ["identifier":singleNews.identifier,"timestamp":timestamp,"content":singleNews.content,"author":singleNews.author]
                
                NewsTimelineData.addObject(newsDict)
                lastsyncStamp = lastsyncStamp.laterDate(timestamp)
                
            }
            
            let dateDescriptor:NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
            var sortedArray:NSArray = NewsTimelineData.sortedArrayUsingDescriptors([dateDescriptor])
            
            NewsTimelineData = NSMutableArray(array: sortedArray)
            
            self.tableView.reloadData()
            
            
        }
        
        //load bmob online data identifier
        
        
        var findTimelineData:BmobQuery = BmobQuery(className: "Company_News")
        findTimelineData.findObjectsInBackgroundWithBlock {
            (objects, error:NSError?) -> Void in
            if error == nil {
                
                for object in objects! {
                    
                    let downloadNews:BmobObject = object as! BmobObject
                    let timestamp:NSDate = downloadNews.createdAt as NSDate
                    
                    
                    // find new added news
                    
                    if (self.lastsyncStamp.compare(timestamp) == NSComparisonResult.OrderedAscending){
                        
                        
                        let newsDict:NSDictionary = ["timestamp":timestamp,"identifier":downloadNews.objectId]
                        self.NewsTimelineData.addObject(newsDict)
                        // reorder with timestamp
                        
                        let dateDescriptor:NSSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                        var sortedArray:NSArray = self.NewsTimelineData.sortedArrayUsingDescriptors([dateDescriptor])
                        
                        self.NewsTimelineData = NSMutableArray(array: sortedArray)
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    
}  // functions

extension ListTableViewController {
    
    func profilePhotoTap(sender:UIGestureRecognizer) {
        
        let touchLoactoin:CGPoint = sender.locationInView(self.tableView)
        
        let indexPath:NSIndexPath = self.tableView.indexPathForRowAtPoint(touchLoactoin)!
        
        let scrollPosition:UITableViewScrollPosition = UITableViewScrollPosition.None
        
        self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: scrollPosition)
        
        self.performSegueWithIdentifier("profileDetail", sender: UITableViewCell())
        
    }
    
}  // rkcradview delegate

extension ListTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("newsDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "newsDetail" {
            
            let comingupViewController: NewsDetailViewController = segue.destinationViewController as! NewsDetailViewController
            
            let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            let itemDict:NSDictionary = NewsTimelineData.objectAtIndex(indexPath.row) as! NSDictionary
            
            comingupViewController.identifier = itemDict.objectForKey("identifier") as! String
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        }
        
        if segue.identifier == "profileDetail" {
            
            let comingupViewController: ProfileDetailViewController = segue.destinationViewController as! ProfileDetailViewController
            
            let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            let itemDict:NSDictionary = NewsTimelineData.objectAtIndex(indexPath.row) as! NSDictionary

            comingupViewController.identifier = itemDict.objectForKey("identifier") as! String
            
        }
        
        
        
        
    }
    
    
    
    
    
    
}  //

















