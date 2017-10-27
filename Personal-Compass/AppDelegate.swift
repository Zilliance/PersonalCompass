//
//  AppDelegate.swift
//  Personal-Compass
//
//  Created by Philip Dow on 5/15/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController
import ZillianceShared

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
        
        // Notifications
        
        LocalNotificationsHelper.shared.notificationCallback = { notificationInfo in
            print("compass:", notificationInfo.compass, "title:", notificationInfo.title, "body:", notificationInfo.body)
            
            // Present the compass summary, and on top of that present the reminder
            // Or present the reminder with an option to go to the compass
            
            let vc = UIStoryboard(name: "Notification", bundle: nil).instantiateInitialViewController() as! NotificationViewController
            
            vc.notificationInfo = notificationInfo
            
            let sheet = MZFormSheetPresentationViewController(contentViewController: vc)
            
            sheet.presentationController?.contentViewSize = CGSize(width: UIDevice.isSmallerThaniPhone6 ? 260 : 300, height: 300)
            sheet.contentViewControllerTransitionStyle = .bounce
            
            self.window?.rootViewController?.topmost().present(sheet, animated: true, completion: nil)
        }
        
        LocalNotificationsHelper.shared.listenToNotifications()
        Analytics.shared.initialize()
        
        return true
    }
    
    /// Called on iOS 9 when notification fires
    /// On iOS 10 UNUserNotificationCenter delegate methods on LocalNotificationHelper are used
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        LocalNotificationsHelper.shared.application(application, didReceive: notification)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        AppEventsLogger.activate(application)
        
    }

}

