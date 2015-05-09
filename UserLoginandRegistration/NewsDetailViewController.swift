//
//  NewsDetailViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 5/7/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var detailNewsTitle: UILabel!
    var identifier:String = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailNewsTitle.text = identifier
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
  
    
    
}















