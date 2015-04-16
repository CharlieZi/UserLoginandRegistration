//
//  LoginPageViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/17/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextFiled: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginBtnClicked(sender: AnyObject) {
        
        let usrEmail = userEmailTextFiled.text
        let usrPword = userPasswordTextField.text
        
        let usrEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("usrEmail")
        let usrPwordStored = NSUserDefaults.standardUserDefaults().stringForKey("usrPword")
        
        
        
        
        if(usrEmail == usrEmailStored){
            if(usrPword == usrPwordStored){
                //LoginSuccesful
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isuserLoggedIn")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }else{
            var myRegAlert = UIAlertController(title: "Alert", message: " Invalid Email or Password", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okRegAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            myRegAlert.addAction(okRegAction)
            
            self.presentViewController(myRegAlert, animated: true, completion: nil)
            
        }
        

        
        
    }


    
    
    
    
    

}
