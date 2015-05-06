//
//  RegisterPageViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit


protocol RegisterDatadelegate{
    func registerData(LoginData:NSDictionary)
}



class RegisterPageViewController: UIViewController{

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    
    var delegate:RegisterDatadelegate? = nil
    

    
    
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
        // Check Email format

        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = RegexHelper(mailPattern)
        
        if !matcher.match(usrEmail) {
            self.displayMyRegAlertMessage("Invalid Email format")
        }
        
        
        // Store Data
        

        
        let UserData : BmobUser = BmobUser()
        UserData.setUserName(usrEmail)
        UserData.setEmail(usrEmail)
        UserData.setPassword(usrPword)
        UserData.setObject("dummy.png", forKey: "profileImage")
        
        
        
        UserData.signUpInBackgroundWithBlock(){
            (succeeded, error: NSError!) -> Void in
            if(succeeded){
                // 注册成功
                var myRegAlert = UIAlertController(title: "Thanks", message: "Registration is complete!", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okRegAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ action in
                    
                    if self.delegate != nil {
                        let LoginData:NSDictionary = ["email":usrEmail,"password":usrPword]
                        self.delegate?.registerData(LoginData)
                    }

                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                myRegAlert.addAction(okRegAction)
                
                self.presentViewController(myRegAlert, animated: true, completion: nil)
                
            }else{
                // 注册失败
                
                self.displayMyRegAlertMessage("Email Taken!")

                
                
            }

        }
        
     
        
    }
    
    func displayMyRegAlertMessage(userMessage:String ){
        
        var myRegAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okRegAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myRegAlert.addAction(okRegAction)
        
        self.presentViewController(myRegAlert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func BacktoLoginBtnClicked(sender: AnyObject) {


        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }

}




