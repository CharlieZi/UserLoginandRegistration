//
//  TimelineTableViewCell.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/21/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNewsContent: UITextView!
    
    
    @IBOutlet weak var companyUser: UILabel!
    
    @IBOutlet weak var companyTimeStamp: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
