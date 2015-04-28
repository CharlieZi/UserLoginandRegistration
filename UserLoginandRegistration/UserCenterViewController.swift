//
//  ViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController {
    
    @IBOutlet weak var LogoutBtn: UIButton!

    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var testLabel: UILabel!
    
    
    
    
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
        
     
        
        if(BmobUser.getCurrentUser() == nil){
            
            LogoutBtn.setTitle("Sign in", forState: UIControlState.Normal)
            
            testLabel.text = "test"
            
            
        }else{
            
            testLabel.text = "dddd"
            
        }
        
        
        

    }


}

extension UserCenterViewController{
    
    // button defination
    
    @IBAction func LogoutBtnClicked(sender: AnyObject) {
        
        BmobUser.logout()
        
        self.performSegueWithIdentifier("loginView", sender: self)
    }
    
}




