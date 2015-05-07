//
//  SWTableViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 5/7/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class SWTableViewController: UITableViewController, SWRearRKCardViewDelegate {

  
    @IBOutlet weak var cardView: SWRearRKCardView!
    var delegate:SWRearRKCardViewDelegate? = nil
    
    override func viewDidLoad() {
        
        cardView.delegate = self
        
        if BmobProfileImageHelper.userDidExist() {
            
            BmobProfileImageHelper.LoadProfileImage({ (profileImage) -> Void in
                self.cardView.profileImageView.image = profileImage
            })
            
        }else{
            
            cardView.profileImageView.image = UIImage(named: "dummy")
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension SWTableViewController {
    
    
    func profilePhotoTap() {
        println("test")
        self.performSegueWithIdentifier("UserCenter", sender: UITableViewCell())
        
    }
    func coverPhotoTap() {
        
    }
    func titleLabelTap() {
        
    }
    
    
}  //delegate SWRKcardview