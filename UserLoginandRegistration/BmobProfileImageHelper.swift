//
//  BmobProfileImageHelper.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 5/6/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import Foundation



typealias profileImageDataResult = (profileImage:UIImage!) -> Void


class BmobProfileImageHelper {
    
    
    
    class func BmobUserPicUpload(filename: String!, image: UIImage!) -> Void {
        
        
        let imageData:NSData = UIImagePNGRepresentation(image)
        let user:BmobUser = BmobUser.getCurrentUser()
        BmobProFile.uploadFileWithFilename(filename+".png", fileData: imageData, block: { (succeeded, error:NSError!, figureName, url) -> Void in
            
            if !succeeded {
                println("error bmobprofile")
            }else{
                
                // update user account
                
                user.setObject(figureName, forKey: "profileImage")
                user.updateInBackgroundWithResultBlock { (succeeded, error:NSError!) -> Void in
                    if !succeeded {
                        println("update error")
                    }else{
                        
                        self.SyncProfileImage(image)
                        
                    }
                }
                
            }
            }) { (percentage) -> Void in
                // upload percentage
                
        }
        
        
    }
    
    class func BmobUserPicDownload(user:BmobUser,block:profileImageDataResult!) -> Void {
        
        let filename:String = user.objectForKey("profileImage")as! String
        var profileImage:UIImage? = UIImage()
        
        BmobProFile.downloadFileWithFilename(filename, block: { (succeeded, error:NSError!, filepath) -> Void in
            if !succeeded {
                println("bmobprofile download error")
            }else{
                
                var image:UIImage = UIImage()
                
                
                if filename == "dummy.png"{
                    image = UIImage(named: "dummy")!
                }else{
                    image = UIImage(contentsOfFile: filepath)!
                }
                
                println(image)
                block(profileImage: image as UIImage)
            }
            
            }) { (percentage) -> Void in
                
        }
        
        
    }
    
    
    
    class func SyncProfileImage(profileImage:UIImage) -> Void {
        let user:BmobUser = BmobUser.getCurrentUser()
        let identifier:String = user.objectId
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let predicate:NSPredicate = NSPredicate(format: "identifier == '\(identifier)'")
        let result:NSArray = SwiftCoreDataHelper.fetchEntitiesForClass(NSStringFromClass(User), withPredicate: predicate, inManagedObjectContext: moc)
        
        if result.count > 0 {
            
            let localUserData = result.lastObject as! User
            localUserData.profileImage = UIImagePNGRepresentation(profileImage)
            SwiftCoreDataHelper.saveManagedObjectContext(moc)
            
        }else{
            
            var addUser:User = SwiftCoreDataHelper.insertManagedObjectOfClass(NSStringFromClass(User), inManagedObjectContext: moc)as! User
            
            addUser.identifier = identifier
            addUser.profileImage = UIImagePNGRepresentation(profileImage)
            SwiftCoreDataHelper.saveManagedObjectContext(moc)
            
            
        }
        
        
    }  //included in upload
    
    class func LoadProfileImage(block:profileImageDataResult) -> Void {
        let user:BmobUser = BmobUser.getCurrentUser()
        let identifier:String = user.objectId
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let predicate:NSPredicate = NSPredicate(format: "identifier == '\(identifier)'")
        let result:NSArray = SwiftCoreDataHelper.fetchEntitiesForClass(NSStringFromClass(User), withPredicate: predicate, inManagedObjectContext: moc)
        
        if result.count > 0 {
            let localUserData:User = result.lastObject as! User
            let profileImage:UIImage = UIImage(data:localUserData.profileImage)!
            println("local")
            block(profileImage: profileImage)
            
        }else{
            

            self.BmobUserPicDownload(user, block: { (profileImage) -> Void in
                println("online")
                block(profileImage: profileImage)
            })
            
        }
        
        
    }
    
}