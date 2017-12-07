//
//  AppDelegate.swift
//  TestingNewArch
//
//  Created by Min Kim on 11/13/17.
//  Copyright © 2017 Min Kim. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    switch shortcutItem.type {
    case "com.minkim.DueLife.addNewToDo":
      self.window!.rootViewController?.dismiss(animated: false, completion: nil)
      
      let rootNavigationViewController = window!.rootViewController as? UINavigationController
      rootNavigationViewController?.popToRootViewController(animated: false)
      let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllViewController") as! ViewController
      let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddToDo") as! AddItemTableViewController
      rootNavigationViewController?.pushViewController(firstVC, animated: false)
      rootNavigationViewController?.pushViewController(newVC, animated: false)
    case "com.minkim.DueLife.today":
      self.window!.rootViewController?.dismiss(animated: false, completion: nil)
      
      let rootNavigationViewController = window!.rootViewController as? UINavigationController
      rootNavigationViewController?.popToRootViewController(animated: false)
      let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodayView") as! TodayViewController
      rootNavigationViewController?.pushViewController(newVC, animated: false)
    case "com.minkim.DueLife.context":
      self.window!.rootViewController?.dismiss(animated: false, completion: nil)
      
      let rootNavigationViewController = window!.rootViewController as? UINavigationController
      rootNavigationViewController?.popToRootViewController(animated: false)
    default:
      print("unknown shortcut")
    }
    
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().barStyle = .black
    let rootNavigationViewController = window!.rootViewController as? UINavigationController
    let rootViewController = rootNavigationViewController?.viewControllers.first as UIViewController?
    rootViewController?.performSegue(withIdentifier: "AllSegue", sender: nil)
    // Override point for customization after application launch.
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
      if granted {
        UserDefaults.standard.set(true, forKey: "NotificationPermission")
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      } else {
        UserDefaults.standard.set(false, forKey: "NotificationPermission")
        print("error!")
        // handle the error
      }
    }
    UNUserNotificationCenter.current().delegate = self
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound, .badge])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    switch response.actionIdentifier {
    case "Complete":
      let identifierString = response.notification.request.identifier
      let ID = String(identifierString.dropLast())
      let toDoModelController = ToDoModelController()
      toDoModelController.checkmarkButtonPressedModel(ID)
    case "Postpone One Hour":
      let identifierString = response.notification.request.identifier
      let ID = String(identifierString.dropLast())
      let toDoModelController = ToDoModelController()
      toDoModelController.postponeNotifications(ID: ID, numberHours: 1)
    case "Postpone One Day":
      let identifierString = response.notification.request.identifier
      let ID = String(identifierString.dropLast())
      let toDoModelController = ToDoModelController()
      toDoModelController.postponeNotifications(ID: ID, numberHours: 24)
    default: print("Unknown Action")
    }
  }
}
