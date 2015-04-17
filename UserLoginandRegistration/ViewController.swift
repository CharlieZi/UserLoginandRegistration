//
//  ViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
//        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isuserLoggedIn")
        
        if(BmobUser.getCurrentUser()==nil){
              self.performSegueWithIdentifier("loginView", sender: self)
        }
        
        

        

    }


    @IBAction func LogoutBtnClicked(sender: AnyObject) {
//        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isuserLoggedIn")
//        NSUserDefaults.standardUserDefaults().synchronize()
        
    BmobUser.logout()
       
    self.performSegueWithIdentifier("loginView", sender: self)

    }
    

}

