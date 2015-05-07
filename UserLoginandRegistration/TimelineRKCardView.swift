//
//  test.swift
//  RKCardExample
//
//  Created by HuCharlie on 4/30/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit



protocol TimelineRKCardViewDelegate{
    func titleLabelTap()
    func coverPhotoTap()
    func profilePhotoTap(test:NSString)
}




class TimelineRKCardView: UIView {
    
    var visualEffectView = UIVisualEffectView()
    var delegate:TimelineRKCardViewDelegate? = nil
    
    var profileImageView = UIImageView()
    var coverImageView = UIImageView()
    var titleLabel = UILabel()
    
    var CP_RATIO:CGFloat = 0.28
    var CORNER_RATIO:CGFloat = 0.015
    var PP_RATIO:CGFloat = 0.247
    var PP_X_RATIO:CGFloat = 0.03
    var PP_Y_RATIO:CGFloat = 0.113
    var PP_BUFF:CGFloat = 3
    var LABEL_Y_RATIO:CGFloat = 0.012
    
    
    
 
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    func setupView() -> Void{
        
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = self.frame.size.width * CORNER_RATIO
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSizeMake(1, 1)
        self.setupPhotos()
    }
    
    func setupPhotos() -> Void{
        
        
        
       
        
        
        let height:CGFloat = self.frame.size.height
        let width:CGFloat =  self.frame.size.width
        let cp_mask:UIView = UIView(frame: CGRectMake(0, 0, width, height * CP_RATIO))
        let pp_mask:UIView = UIView(frame: CGRectMake(width * PP_X_RATIO, height * PP_Y_RATIO, height * PP_RATIO, height * PP_RATIO))
        let pp_circle:UIView = UIView(frame: CGRectMake(pp_mask.frame.origin.x - PP_BUFF, pp_mask.frame.origin.y - PP_BUFF, pp_mask.frame.size.width + 2 *  PP_BUFF, pp_mask.frame.size.height + 2 * PP_BUFF))

        pp_circle.backgroundColor = UIColor.whiteColor()
        pp_circle.layer.cornerRadius = pp_circle.frame.size.height/2
        pp_mask.layer.cornerRadius = pp_mask.frame.size.height/2
        cp_mask.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        
        let cornerRadius:CGFloat = self.layer.cornerRadius
        
        let maskPath:UIBezierPath = UIBezierPath(roundedRect: cp_mask.bounds, byRoundingCorners: UIRectCorner.TopLeft | UIRectCorner.TopLeft , cornerRadii: CGSizeMake(cornerRadius, cornerRadius))
        
        let maskLayer:CAShapeLayer = CAShapeLayer()
        
        
        
        maskLayer.frame = cp_mask.bounds
        maskLayer.path = maskPath.CGPath
        cp_mask.layer.mask = maskLayer
        
        let blurEffect:UIBlurEffect = UIBlurEffect()
        
        
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        
        visualEffectView.frame = cp_mask.frame
//        visualEffectView.alpha = 0
        
        
        profileImageView.frame = CGRectMake(0, 0, pp_mask.frame.size.width, pp_mask.frame.size.height)
        
        
        
        
        
        coverImageView.frame = cp_mask.frame
        coverImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        
        cp_mask.addSubview(coverImageView)
        pp_mask.addSubview(profileImageView)
        cp_mask.clipsToBounds = true
        pp_mask.clipsToBounds = true
        
 
    
    // Setup the label
        
        let titleLabelX:CGFloat = pp_circle.frame.origin.x + pp_circle.frame.size.width

        
        
        titleLabel = UILabel(frame: CGRectMake(titleLabelX, cp_mask.frame.size.height + 7, self.frame.size.width - titleLabelX, 26))
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = NSLineBreakMode.ByClipping
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        titleLabel.text = "Title Label"
        
        
        
    // Register touch events on the label
        
        
        titleLabel.userInteractionEnabled = true
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "titleLabelTap")as UITapGestureRecognizer
        titleLabel.addGestureRecognizer(tapGesture)


     // Register touch events on the cover image
        
        coverImageView.userInteractionEnabled = true
        let tapGestureCover:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "coverPhotoTap")as UITapGestureRecognizer
        coverImageView.addGestureRecognizer(tapGestureCover)
        
        
    // Register touch events on the profile imate
        
        profileImageView.userInteractionEnabled = true
        let tapGestureProfile:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "profilePhotoTap")as UITapGestureRecognizer
        profileImageView.addGestureRecognizer(tapGestureProfile)
        
    // building upp the views
        
        self.addSubview(titleLabel)
        self.addSubview(cp_mask)
        self.addSubview(pp_circle)
        self.addSubview(pp_mask)
        coverImageView.addSubview(visualEffectView)
        
    }
    
    
    
    
    
    
    
}
extension TimelineRKCardView{
    
    
    func titleLabelTap() -> Void{
        if delegate != nil
        {
            self.delegate!.titleLabelTap()
 
        }else{
        }
    }
    
    func coverPhotoTap() -> Void{
        if delegate != nil
        {
            self.delegate!.coverPhotoTap()
        }else{
            
        }
    }
    
    func profilePhotoTap() -> Void{
        if (delegate != nil)
        {
            self.delegate!.profilePhotoTap("test")
        }else{
            
        }
    }

    
    
    
    func addBlur() -> Void{
        visualEffectView.alpha = 1
    }
  
    func removeBlur() -> Void{
        visualEffectView.alpha = 0
    }
    
    
    func addShadow() -> Void{
        self.layer.shadowOpacity = 0.15
    }
    
    func removeShadow() -> Void{
        self.layer.shadowOpacity = 0
    }
    
    
    
} // methods












