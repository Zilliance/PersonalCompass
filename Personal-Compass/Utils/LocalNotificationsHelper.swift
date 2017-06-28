//
//  LocalNotificationsHelper.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 05-06-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import Foundation

import Foundation
import UserNotifications
import UIKit

struct NotificationInfo {
    let compass: Compass
    let title: String
    let body: String
}

final class LocalNotificationsHelper: NSObject
{
    static let notificationCategory = "reminderNotification"
    static let shared = LocalNotificationsHelper()
    
    fileprivate var waitingAuthorizationCompletion: ((Bool) -> ())?
    var notificationCallback: ((NotificationInfo) -> ())?
    
    private func ownAuthorization(vc: UIViewController, completion: @escaping (Bool) -> ())
    {
        
        let alert = UIAlertController(title: "Allow Notifications", message: "Personal Compass would like to send you a notification reminder", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            completion(false)
        }))
        
        alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: { (_) in
            completion(true)
        }))
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    func requestAuthorization(inViewController viewController: UIViewController, completion: @escaping (Bool) -> ())
    {
        
        let ownAuthorization:() -> () =
        {
            self.ownAuthorization(vc: viewController, completion: { (authorized) in
                if (authorized)
                {
                    self.requestOSAuthorization(completion: completion)
                }
            })
        }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            
            center.getNotificationSettings(completionHandler: {(settings) in
                
                DispatchQueue.main.async {
                    if (settings.authorizationStatus == .authorized)
                    {
                        completion(true)
                    }
                    else
                    {
                        if (settings.authorizationStatus == .notDetermined)
                        {
                            ownAuthorization()
                        }
                        else
                        {
                            completion(false)
                        }
                    }
                    
                }
            })
            
        } else {
            
            
            if let types = UIApplication.shared.currentUserNotificationSettings?.types, types.contains([.alert, .sound])
            {
                completion(true)
                return
            }
            else
            {
                ownAuthorization()
            }
            
            
        }
    }
    
    private func requestOSAuthorization(completion: ((Bool) -> ())?)
    {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                DispatchQueue.main.async {
                    completion?(granted)
                }
            }
        } else {
            
            self.waitingAuthorizationCompletion = completion
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .sound], categories: nil))
            
        }
        
    }
    
    func authorizationReceived(authorized: Bool)
    {
       self.waitingAuthorizationCompletion?(authorized)
    }
    
    static func scheduleLocalNotification(title: String, body: String, date: Date, identifier: String)
    {
        if #available(iOS 10.0, *) {
            // no need to remove in iOS 10 since it's automatically updated using the identifier information

            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = notificationCategory
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default()
            
            let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            // Schedule the notification.
            center.add(request) { (error) in
            }
            
        } else {
            guard let settings = UIApplication.shared.currentUserNotificationSettings, settings.types != .none else {
                return
            }
            
            self.removeNotificationsForIdentifier(identifier: identifier)
            
            let notification = UILocalNotification()
            notification.fireDate = date
            notification.alertTitle = title
            notification.alertBody = body
            notification.soundName = UILocalNotificationDefaultSoundName
            
            notification.userInfo = ["identifier": identifier]
            
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    static func getInformationForStoredNotification(identifier: String) -> (String, Date)? {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            
            
            let dispatchGroup = DispatchGroup()
            var previousRequest:UNNotificationRequest?
            
            dispatchGroup.enter()
            
            center.getPendingNotificationRequests(completionHandler: { (notificationRequest) in
                
                previousRequest = notificationRequest.first
                dispatchGroup.leave()
            })
            
            dispatchGroup.wait()

            if let previousRequest = previousRequest, let trigger = previousRequest.trigger as? UNCalendarNotificationTrigger, let date = trigger.nextTriggerDate() {
                
                return (previousRequest.content.body, date)
            }
            
            
        } else {
            
            let notifications = UIApplication.shared.scheduledLocalNotifications?.filter({ (notification) -> Bool in
                guard let userInfo = notification.userInfo, let nIdentifier = userInfo["identifier"] as? String else { return false }
                return nIdentifier == identifier
            })
            
            if let notification = notifications?.first, let text = notification.alertBody, let date = notification.fireDate {
                return (text, date)
            }
            
        }
        
        return nil
        
    }
    
    static func removeNotificationsForIdentifier(identifier: String) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        } else {
            
            let notifications = UIApplication.shared.scheduledLocalNotifications?.filter({ (notification) -> Bool in
                guard let userInfo = notification.userInfo, let nIdentifier = userInfo["identifier"] as? String else { return false }
                return nIdentifier == identifier
            })
            
            if let notification = notifications?.first {
                UIApplication.shared.cancelLocalNotification(notification)
            }
            
        }
        
    }
    
    
}

// MARK: - iOS 10 Notifications

extension LocalNotificationsHelper: UNUserNotificationCenterDelegate {
    
    func listenToNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            
        }
    }
    
    /// Called on iOS 10 when app is in foreground, we're instructing system to still show the notification
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.badge])
    }
    
    /// Called on iOS 10 when the user taps a notification, whether while the app is in the background or the foreground
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        // Realm won't return the compass if it hasn't been saved yet or has been deleted
        
        if  let id = response.notification.request.identifier.components(separatedBy: "::").first,
            let compass = Database.shared.realm.object(ofType: Compass.self, forPrimaryKey: id) {
            let title = response.notification.request.content.title
            let body = response.notification.request.content.body
        
            self.notificationCallback?(NotificationInfo(compass: compass, title: title, body: body))
        }
        
        completionHandler()
    }
    
}

// MARK: - iOS 9 Notifications

extension LocalNotificationsHelper {
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        // Realm won't return the compass if it hasn't been saved yet or has been deleted
        
        if  let notId = notification.userInfo?["identifier"] as? String,
            let id = notId.components(separatedBy: "::").first,
            let compass = Database.shared.realm.object(ofType: Compass.self, forPrimaryKey: id),
            let title = notification.alertBody,
            let body = notification.alertTitle {
            
            self.notificationCallback?(NotificationInfo(compass: compass, title: title, body: body))
        }
    }
}
