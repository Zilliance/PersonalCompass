//
//  AppDelegate.swift
//  Personal-Compass
//
//  Created by Philip Dow on 5/15/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        _ = Database.shared.appStarted()
        
        // App wide appearance
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .navBar
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.muliBold(size: 16)
        ]
        
        var rootViewController: UIViewController?
        
        if UserDefaults.standard.bool(forKey: "IntroShowed") {
            let sideMenuViewController = CustomSideViewController()
            sideMenuViewController.setupStartCompass()
            rootViewController = sideMenuViewController
        }
        else {
            UserDefaults.standard.set(true, forKey: "IntroShowed")
            rootViewController = UIStoryboard(name: "Intro", bundle: nil).instantiateInitialViewController()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        LocalNotificationsHelper.shared.listenToNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        guard application.applicationState == .active else {
            return
        }
        
        //this will only be exectuted on iOS 9. On iOS 10 we use the UNUserNotificationCenter methods
        let alert = UIAlertController(title: notification.alertTitle, message: notification.alertBody, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    

}

