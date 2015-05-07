//
//  ViewController.swift
//  UserLoginandRegistration
//
//  Created by HuCharlie on 4/16/15.
//  Copyright (c) 2015 HuCharlie. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController,UserCenterRKCardViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  
    
    @IBOutlet weak var cardView: UserCenterRKCardView!
    
    
    @IBOutlet weak var LogoutBtn: UIButton!

    @IBOutlet weak var SlideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var testLabel: UILabel!
    
    
    // life cycle start
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SlideMenuBtn.target = self.revealViewController()
        SlideMenuBtn.action = Selector("revealToggle:")
        
        
        
        cardView.titleLabel.text = "test"
        cardView.coverImageView.image = UIImage(named: "cat")
        cardView.removeBlur()
        cardView.delegate = self
        
        if userDidExist() {
            BmobProfileImageHelper.LoadProfileImage { (profileImage) -> Void in
                self.cardView.profileImageView.image = profileImage
            }
        }else{
            cardView.profileImageView.image = UIImage(named: "dummy")
        }
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
     
        
        if userDidExist() {
            
            LogoutBtn.setTitle("Sign out", forState: UIControlState.Normal)
            
        }else{
            
            LogoutBtn.setTitle("Sign in", forState: UIControlState.Normal)

            
        }
        
        
        

    }
    
    // life cycle end

}

extension UserCenterViewController {
    
    // button defination
    
    @IBAction func LogoutBtnClicked(sender: AnyObject) {
        
        BmobUser.logout()
        
        self.performSegueWithIdentifier("loginView", sender: self)
    }
    
    
    @IBAction func uploadBtnClicked(sender: AnyObject) {
        
        let image:UIImage = UIImage(named: "cat")!
        
        BmobProfileImageHelper.BmobUserPicUpload("cat", image: image)
        
        
        
    }
    
    
    
    
    
    
    
}

extension UserCenterViewController {
    
    // my func
    
    func userDidExist()->Bool{
        
        let userStatus:Bool = (BmobUser.getCurrentUser() == nil) as Bool
        if userStatus {
            
            return false
            
        }else{
            
            return true
            
        }
    }
}

extension UserCenterViewController {
    
    
    
    
    func profilePhotoTap() {
        if userDidExist(){
            let imagePicker:UIImagePickerController = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true  , completion: nil)
            

        }else{
            println("not login yet")
        }
    }
    
    func coverPhotoTap() {
        
    }
    
    func titleLabelTap() {
        
    }
    
} //delegate

extension UserCenterViewController {
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let pickedImage:UIImage = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
        
        let smallPicture = scaleImageWidth(pickedImage, newSize: CGSizeMake(100, 100))
        
        var sizeOfImageView:CGRect =  cardView.profileImageView.frame
        sizeOfImageView.size = smallPicture.size
        cardView.profileImageView.frame = sizeOfImageView
        cardView.profileImageView.image = smallPicture
        
    
        BmobProfileImageHelper.BmobUserPicUpload(BmobUser.getCurrentUser().objectId, image: smallPicture)
     
      
      
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scaleImageWidth(image:UIImage,newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage
        
        
    }
    
    
    

    
    
} // profile image Picker










