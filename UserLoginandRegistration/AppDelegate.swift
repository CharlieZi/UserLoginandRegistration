//
//  AppDelegate.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ICETutorialControllerDelegate {

    var window: UIWindow?
    var viewController:ICETutorialController?
    
    
    
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // bmob setup
        
        Bmob.registerWithAppKey("b9231fb2e6a12e64cf048063dcafca08")
        
        
        // UI Setup
        
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//        UINavigationBar.appearance().barTintColor =  UIColor(red: 0.66, green: 0.78, blue: 0.31, alpha: 1)
//        UIButton.appearance().tintColor = UIColor(red: 0.66, green: 0.78, blue: 0.31, alpha: 1)
        
        
        // first Run
        
        
        let tutorialLayers:NSArray = picGallerySetup()as NSArray
        self.viewController = ICETutorialController(pages: tutorialLayers as [AnyObject], delegate: self)
        
        var titleStyle:ICETutorialLabelStyle = ICETutorialLabelStyle(font: UIFont(name: "Helvetica-Bold", size: 27.0 as CGFloat), textColor: UIColor.whiteColor(), linesNumber: 2, offset: 180)
        
        ICETutorialStyle.sharedInstance().titleStyle = titleStyle
        ICETutorialStyle.sharedInstance().subTitleColor = UIColor.whiteColor()
        ICETutorialStyle.sharedInstance().subTitleOffset = 150
        
        
        self.viewController!.startScrolling()
        self.window?.rootViewController = self.viewController
        self.window?.makeKeyAndVisible()
      
        
        return true
        
        
    }
    
    
    
    // image setup
    func picGallerySetup() -> NSArray {
        
        let layer1:ICETutorialPage = ICETutorialPage(title: "Picture 1", subTitle: "Champs-Elysées by night", pictureName: "tutorial_background_00", duration: 3.0)as ICETutorialPage
        
        let layer2:ICETutorialPage = ICETutorialPage(title: "Picture 1", subTitle: "Champs-Elysées by night", pictureName: "tutorial_background_01", duration: 3.0)as ICETutorialPage
        
        let layer3:ICETutorialPage = ICETutorialPage(title: "Picture 1", subTitle: "Champs-Elysées by night", pictureName: "tutorial_background_02", duration: 3.0)as ICETutorialPage
        
        let layer4:ICETutorialPage = ICETutorialPage(title: "Picture 1", subTitle: "Champs-Elysées by night", pictureName: "tutorial_background_03", duration: 3.0)as ICETutorialPage
        
        let layer5:ICETutorialPage = ICETutorialPage(title: "Picture 1", subTitle: "Champs-Elysées by night", pictureName: "tutorial_background_04", duration: 3.0)as ICETutorialPage
        
        let tutorialLayers:NSArray = [layer1,layer2,layer3,layer4,layer5]
        
        
        return tutorialLayers
        
    }
    
    //icetutorial delegate
    
    func tutorialController(tutorialController: ICETutorialController!, didClickOnLeftButton sender: UIButton!) {
        
        println("another test")
    }
    
    func tutorialController(tutorialController: ICETutorialController!, didClickOnRightButton sender: UIButton!) {
        
        let viewController:SWRevealViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController")as! SWRevealViewController
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController?.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func tutorialController(tutorialController: ICETutorialController!, scrollingFromPageIndex fromIndex: UInt, toPageIndex toIndex: UInt) {
        
        
    }
    
    func tutorialControllerDidReachLastPage(tutorialController: ICETutorialController!) {
        
        
        self.viewController?.stopScrolling()
        
        
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "TJ-University.UserLoginandRegistration" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("UserLoginandRegistration", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("UserLoginandRegistration.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()

}


extension AppDelegate {
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
     // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
}

