//
//  revealViewGesture.swift
//  slideOutMenu
//
//  Created by HuCharlie on 4/17/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import Foundation


class ComposeViewController: UIViewController {
    
    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var ComposeTextView: UITextView!
    
    @IBOutlet weak var ComposeCounter: UILabel!
    
    
    
    // life cycle start
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ComposeTextView.layer.borderColor = UIColor.blackColor().CGColor
        ComposeTextView.layer.borderWidth = 0.5
        ComposeTextView.layer.cornerRadius = 5
        
        
        SlideMenuBtn.target = self.revealViewController()
        SlideMenuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        
        let localImage = UIImage(named: "dummy")
        
        BmobProfileImageHelper.BmobUserPicUpload("test", image: localImage)
        
       
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // life cycle end
        
}


extension ComposeViewController {
    
    @IBAction func DoneBtnClicked(sender: AnyObject) {
        
        var companyNews:BmobObject = BmobObject(className: "Company_News")
        companyNews.setObject(ComposeTextView.text, forKey: "Content")
        if BmobUser.getCurrentUser() == nil {
            println("not login yet")
            
        }else{
            companyNews.setObject(BmobUser.getCurrentUser().objectId, forKey: "Company")
            if ComposeTextView.hasText(){
                companyNews.saveInBackgroundWithResultBlock { (succeed, error:NSError!) -> Void in
                    if succeed {
                        println("compose successful")
                        
                        let viewController:SWRevealViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController")as! SWRevealViewController
                        
                        self.presentViewController(viewController, animated: true, completion: nil)
                        
                    }else{
                        println("compose failed")
                    }
                }
            }else{
                println("textField Empty!")
            }
            
            
        }
        
    }

}
































