//
//  AppDelegate.swift
//  Skillbox2.9.4
//
//  Created by Артём on 1/26/21.
//


// Swift
//
// AppDelegate.swift
import UIKit
import FBSDKCoreKit
import VK_ios_sdk
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        
        VKSdk.initialize(withAppId: "7741974")?.uiDelegate = self
        VKSdk.instance()?.uiDelegate = self
        VKSdk.instance()?.unregisterDelegate(self)
        
        GIDSignIn.sharedInstance().clientID = "8281278736-2oe328n15akc0510iqmm7lat7cbtopml.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        
        
        
//        VKSdk.authorize(["email, groups"])
        

        return true
    }
          
    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        ApplicationDelegate.shared.application(app,open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        VKSdk.processOpen(url, fromApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
//        GIDSignIn.sharedInstance()?.handle(url)
        
        return (GIDSignIn.sharedInstance()?.handle(url))!

    }
}

extension AppDelegate: VKSdkDelegate{
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        
        if (result!.token != nil){
            print("успешная авторизация")
        }else{
            print("ошибка авторизации")
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("авторизация vkSdkUserAuthorizationFailed не прошла")
    }
    
    
}


extension AppDelegate: VKSdkUIDelegate{
    func vkSdkShouldPresent(_ controller: UIViewController!) {
//        let vc = UIApplication.shared.keyWindow?.rootViewController
        let vc = UIApplication.shared.keyWindowInConnectedScenes?.rootViewController
        if vc?.presentedViewController != nil {
            vc?.dismiss(animated: true, completion: {
                print("hide current controller if presents")
                vc?.present(controller, animated: true, completion: {
                    print("SFSafariViewController opened to login through the browser")
                })
            })
        }else{
            vc?.present(controller, animated: true, completion: {
                print("SFSafariViewController opened to login through the browser")
            })
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(vkSdkNeedCaptchaEnter)
    }
}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
              print("The user has not signed in before or they have since signed out.")
            } else {
              print("\(error.localizedDescription)")
            }
            return
          }
          // Perform any operations on signed in user here.
          let userId = user.userID                  // For client-side use only!
          let idToken = user.authentication.idToken // Safe to send to the server
          let fullName = user.profile.name
          let givenName = user.profile.givenName
          let familyName = user.profile.familyName
          let email = user.profile.email
          // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
        print("user has been disconnected")
    }
    
    
}

extension UIApplication {

    /// The app's key window taking into consideration apps that support multiple scenes.
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }

}
    


//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//
//}

