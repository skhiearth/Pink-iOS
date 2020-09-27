//
//  AppDelegate.swift
//  Pink+
//
//  Created by Utkarsh Sharma on 18/09/20.
//

import UIKit
import Firebase
import WatchConnectivity

@main
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    var session: WCSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        self.configureWatchKitSesstion()
        
        if let validSession = self.session, validSession.isReachable {
            let data: [String: Any] = ["iPhone": "Data from iPhone" as Any]
            validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
        
        return true
    }
    
    func configureWatchKitSesstion() {
        if WCSession.isSupported() {
          session = WCSession.default
          session?.delegate = self
          session?.activate()
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
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
      
    func sessionDidDeactivate(_ session: WCSession) {
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
    }

}
