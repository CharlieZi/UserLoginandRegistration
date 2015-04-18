//
//  revealViewGesture.swift
//  slideOutMenu
//
//  Created by HuCharlie on 4/17/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import Foundation


class revealViewGesture_WatchList: UIViewController {
    
    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SlideMenuBtn.target = self.revealViewController()
        SlideMenuBtn.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}