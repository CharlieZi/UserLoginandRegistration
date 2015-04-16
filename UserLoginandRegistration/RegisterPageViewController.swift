//
//  RegisterPageViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func registerBtnClicked(sender: AnyObject) {
        
        let usrEmail = userEmailTextField.text
        let usrPword = userPasswordTextField.text
        
        // Check empty field
        
        if (usrEmail.isEmpty || usrPword.isEmpty){
            
            // display message and return
            displayMyRegAlertMessage("All fields are required!")
            return
        }
        
        // Store Data
        
        // display alert message with confirmation
        
    
        
        
    }
    
    func displayMyRegAlertMessage(userMessage:String ){
        
        var myRegAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okRegAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myRegAlert.addAction(okRegAction)
        
        self.presentViewController(myRegAlert, animated: true, completion: nil)
        
    }

}









