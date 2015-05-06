//
//  BmobCoreDataHelper.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 5/5/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import Foundation


typealias cellUIView = (profileImage:UIImage!,author:String!,content:String!) -> Void



class BmobCoreDataHelper{
    
    
    
    class func LoadBmobDataNotInCoredata(BmobClassName:String!,itemDict:NSDictionary,block:cellUIView!) -> Void {
        
        let identifier:String = itemDict.objectForKey("identifier")as! String
        var loadTimelineData:BmobQuery = BmobQuery(className: BmobClassName)

        loadTimelineData.getObjectInBackgroundWithId(itemDict.objectForKey("identifier")as! String, block: { (singleNews, error:NSError!) -> Void in
            if error == nil {
                let content:String = singleNews.objectForKey("Content")as! String
                let timestamptemp:NSDate = singleNews.createdAt
                var findUserName:BmobQuery = BmobUser.query()
                
                findUserName.getObjectInBackgroundWithId(singleNews.objectForKey("Company")as! String, block: { (user, error:NSError!) -> Void in
                    if error == nil {
                        let author:String = user.objectForKey("username") as! String
                        BmobProfileImageHelper.BmobUserPicDownload(user as! BmobUser, block: { (profileImage) -> Void in
                            
                            println(user.objectForKey("profileImage"))
                            
                            
                            
                            let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
                            var addNews:News = SwiftCoreDataHelper.insertManagedObjectOfClass(NSStringFromClass(News), inManagedObjectContext: moc) as! News
                            addNews.profileImage = UIImagePNGRepresentation(profileImage)
                            addNews.author = author
                            addNews.identifier = identifier
                            addNews.content = content
                            addNews.timestamp = itemDict.objectForKey("timestamp")as! NSDate
                            SwiftCoreDataHelper.saveManagedObjectContext(moc)
                            
                            block(profileImage:profileImage,author:author,content:content)
                            
//                            
//                                                        
                        })
                        
                        
                    }
                })
                
                
            }
        })
        
    }
    
    
  
    
    
}