//
//  AppDelegate.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 19.02.2023.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL)
        } catch {
            print("Error occurs during creating Realm:\(error)")
        }

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = CalendarViewController()
//        window?.makeKeyAndVisible()
//
        return true
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

    
    func applicationDidEnterBackground(_ application: UIApplication) {

        print("I'm in back now...")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

        print("I'm from background....")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("I'm terminating....")
    }
    

}

