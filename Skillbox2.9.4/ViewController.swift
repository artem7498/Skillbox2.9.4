//
//  ViewController.swift
//  Skillbox2.9.4
//
//  Created by Артём on 1/26/21.
//googleid:     8281278736-2oe328n15akc0510iqmm7lat7cbtopml.apps.googleusercontent.com

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import VK_ios_sdk
import GoogleSignIn

class ViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
          // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

    }

    @IBAction func googleSignInButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindowInConnectedScenes!.rootViewController!
            while (topController.presentedViewController != nil) {
                topController = topController.presentedViewController!
            }
            return topController
        }
    
    @IBAction func VKLoginButton(_ sender: Any) {
        VKSdk.authorize(["email", "friends", "wall"])
//        if VKAuthorizationResult.
        if VKSdk.isLoggedIn(){
            let topVC = topMostController()
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
            topVC.present(nvc, animated: true, completion: nil)
            print("access token created")
            
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        if AccessToken.current != nil{
            let topVC = topMostController()
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
            topVC.present(nvc, animated: true, completion: nil)
        }else{
            let manager = LoginManager()
            manager.logIn(permissions: [Permission.publicProfile, Permission.userFriends], viewController: self) { loginResult in
                switch loginResult{
                case .success(granted: let granted, declined: let declined, token: let token):
                    print("loged in")
                    let nvc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
                    self.present(nvc, animated: true, completion: nil)
                case .cancelled:
                    print("canceled by user")
                case .failed(let error):
                    print(error)
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = AccessToken.current, !token.isExpired {
            print("okkk")
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
            self.present(nvc, animated: true, completion: nil)
        } else if VKSdk.isLoggedIn(){
            
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
            self.present(nvc, animated: true, completion: nil)
            print("access token created vda")
            
        } else if GIDSignIn.sharedInstance()?.currentUser != nil{
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
            self.present(nvc, animated: true, completion: nil)
            print("access token created vda google")
        }
    }


}

extension ViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
              print("The user has not signed in before or they have since signed out.")
            } else {
              print("\(error.localizedDescription)")
            }
            return
          }
        
        
        if error == nil{
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
            self.present(nvc, animated: true, completion: nil)
            print(user.userID!)
            print(user.profile.email!)
            print(user.profile.familyName!)
        }
        
        
        
        /*  // Perform any operations on signed in user here.
          let userId = user.userID                  // For client-side use only!
          let idToken = user.authentication.idToken // Safe to send to the server
          let fullName = user.profile.name
          let givenName = user.profile.givenName
          let familyName = user.profile.familyName
          let email = user.profile.email
         */
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
        print("user has been disconnected")
    }
}

extension ViewController: VKSdkDelegate{
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        
        if (result.token != nil){
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
            self.present(nvc, animated: true, completion: nil)
        }else{
            print("ошибка авторизации")
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("авторизация vkSdkUserAuthorizationFailed не прошла")
    }
    
    
}



