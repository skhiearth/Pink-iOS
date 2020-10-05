//
//  AppDelegate.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 27/09/20.
//

import UIKit
import Firebase
import WatchConnectivity
import SVProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var session: WCSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        self.configureWatchKitSesstion()
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        
        if ((uid) != nil) {
            setAuthWatch(value: "Yes")
        } else {
            setAuthWatch(value: "No")
        }
        
        return true
    }
    
    func setAuthWatch(value: String){
        if let validSession = self.session, validSession.isReachable {
            let data: [String: Any] = ["Auth": value as Any]
            validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: WCSessionDelegate {
    
    func configureWatchKitSesstion() {
        if WCSession.isSupported() {
            print("Session init")
          session = WCSession.default
          session?.delegate = self
          session?.activate()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
      
    func sessionDidDeactivate(_ session: WCSession) {
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        SVProgressHUD.showSuccess(withStatus: "delegate got it")
    }
}
