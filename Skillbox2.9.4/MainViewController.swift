//
//  MainViewController.swift
//  Skillbox2.9.4
//
//  Created by Артём on 1/26/21.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import DropDown
import MobileCoreServices
import VK_ios_sdk
import GoogleSignIn


class MainViewController: UIViewController {
    
    let dropDown = DropDown()
    let picker = UIImagePickerController()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(VKSdk.accessToken())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: UIBarButtonItem.Style.plain, target: self, action: #selector(openDropDownMenu))
    }
    
    
    
    @IBAction func showFriendsButton(_ sender: Any) {
        performSegue(withIdentifier: "friends", sender: (Any).self)
    }
    
    
    @objc func openDropDownMenu(){
        dropDown.anchorView = self.navigationItem.rightBarButtonItem
        dropDown.dataSource = ["Link", "Photo", "Video"]
        dropDown.show()
        dropDown.width = 150
        dropDown.selectionBackgroundColor = UIColor.lightGray
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            switch index {
            case 0:
                shareLink(url: URL(string: "https://developers.facebook.com/docs/sharing/ios/")!)
            case 1:
//                sharePhoto()
            print("photo shared")
            case 2:
//                shareVideo()
                print("video shared")
            
            default:
                break
            }
            
        }
    }
    
    func shareLink(url: URL){
        
        if AccessToken.current != nil{
            let linkshare = ShareLinkContent()
            linkshare.contentURL = url
            linkshare.quote  = "This is test, please do not reply"
            
            let shareDialoge = ShareDialog(fromViewController: self, content: linkshare, delegate: .none)
            shareDialoge.mode = .browser
            shareDialoge.show()
        } else if  VKSdk.isLoggedIn(){
            let shareDialog = VKShareDialogController()
            shareDialog.text = "This post created using #vksdk #ios"
//            shareDialog.vkImages = ["-10889156_348122347", "7840938_319411365", "-60479154_333497085"]
            shareDialog.shareLink = VKShareLink(title: "this is TEST", link: url)
            shareDialog.completionHandler = { VKShareDialogController, result in
                self.dismiss(animated: true, completion: nil)
            }
            self.present(shareDialog, animated: true, completion: nil)
            
        }
        
    }

    
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        if AccessToken.current != nil{
            AccessToken.current = nil
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(vc, animated: true, completion: nil)
        } else if VKSdk.isLoggedIn(){
            VKSdk.forceLogout()
            if !VKSdk.isLoggedIn(){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(vc, animated: true, completion: nil)
                VKAccessToken.description()
                print("vk logged out")
            }
            
        } else if GIDSignIn.sharedInstance()?.currentUser != nil{
            GIDSignIn.sharedInstance()?.signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(vc, animated: true, completion: nil)
            print(GIDSignIn.sharedInstance()?.currentUser)
            
        }
        
        
        
    }
  
}

