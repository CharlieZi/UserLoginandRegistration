//
//  ListTableViewCell.swift
//  BmobSync
//
//  Created by HuCharlie on 4/24/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit


class WatchListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var CellUIView: UIView!
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsContent: UITextView!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsTimestamp: UILabel!
    
    
    @IBOutlet weak var likeBtn: UIButton!
        
    @IBOutlet weak var likeCounter: UILabel!
  
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
