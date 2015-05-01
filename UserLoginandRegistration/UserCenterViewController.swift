//
//  ViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController {
    
  
    
    @IBOutlet weak var cardView: UserCenterRKCardView!
    
    
    @IBOutlet weak var LogoutBtn: UIButton!

    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var testLabel: UILabel!
    
    
    // life cycle start
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SlideMenuBtn.target = self.revealViewController()
        SlideMenuBtn.action = Selector("revealToggle:")
        
        
        
        cardView.titleLabel.text = "test"
        cardView.profileImageView.image = UIImage(named: "dummy")
        cardView.coverImageView.image = UIImage(named: "cat")
        cardView.removeBlur()
        
        
        
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        println(userDidExist())
     
        
        if(self.userDidExist()){
            
            LogoutBtn.setTitle("Sign in", forState: UIControlState.Normal)
            
            
        }else{
            
            LogoutBtn.setTitle("Sign out", forState: UIControlState.Normal)
            

            
        }
        
        
        

    }
    
    // life cycle end

}

extension UserCenterViewController{
    
    // button defination
    
    @IBAction func LogoutBtnClicked(sender: AnyObject) {
        
        BmobUser.logout()
        
        self.performSegueWithIdentifier("loginView", sender: self)
    }
    
}

extension UserCenterViewController{
    
    // my func
    
    func userDidExist()->Bool{
        
        let userStatus:Bool = (BmobUser.getCurrentUser() == nil) as Bool
        if userStatus {
            
            return true
            
        }else{
            
            return false
            
        }
    }
}













