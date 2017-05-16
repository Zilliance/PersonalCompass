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
        
        // App wide appearance
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .darkBlue
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.muliBold(size: 18)
        ]
        
        let sideMenuViewController = CustomSideViewController()
        sideMenuViewController.setupStartCompass()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = sideMenuViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

