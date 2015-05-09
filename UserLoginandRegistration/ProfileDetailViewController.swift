//
//  ProfileDetailViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 5/9/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController {

    
    var identifier:String = String()
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleLabel.text = identifier
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
