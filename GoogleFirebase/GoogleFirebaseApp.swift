//
//  GoogleFirebaseApp.swift
//  GoogleFirebase
//
//  Created by Maxim Macari on 05/10/2020.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct GoogleFirebaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // perform action when user logs out
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // perform action when user logs in
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        
        //Logging to firebase...
        
        Auth.auth().signIn(with: credential) { (res, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            //user Logged in succesfully
            print("LoggedIn successfully")
            //Sending Notification to UI
            
            NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"), object: nil)
            
            //Printing email id
            print(res?.user.email!, " ", res?.user.displayName!)
        }
    }
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    FirebaseApp.configure() // Initializing Auth
    
    //Initializing google
    GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance()?.delegate = self
    
    return true
  }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}
