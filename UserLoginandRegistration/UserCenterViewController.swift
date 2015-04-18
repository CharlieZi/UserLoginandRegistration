//
//  ViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController {
    

    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SlideMenuBtn.target = self.revealViewController()
        SlideMenuBtn.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
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

