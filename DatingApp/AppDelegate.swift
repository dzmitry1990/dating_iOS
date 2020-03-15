//
//  AppDelegate.swift
//  DatingApp
//
//  Created by AJ on 04/08/2019.
//  Copyright © 2019 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import UserNotifications
import SwiftyStoreKit
import TwitterKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
     var swipeItems:[Profiles] = []
    var controller:UIViewController?
    var notification:Bool = false
     
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Mark - Hockey App
       // BITHockeyManager.shared().configure(withIdentifier: "7804d0315cf7452aa6c6481e475fe35f")
        //BITHockeyManager.shared().start()
        
        registerForRemoteNotification()
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        //USER LOGIN STATUS
        if let value = UserDefaults.standard.value(forKey: "UserExist") as? String{
            if(value == "1"){
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
                self.window?.rootViewController = secondViewController
            }
            else{
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "IntialVC")
                self.window?.rootViewController = secondViewController
            }
        }
        else{
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "IntialVC")
            self.window?.rootViewController = secondViewController

        }
        
        
        //for twitter sharing
//        TWTRTwitter.sharedInstance().start(withConsumerKey:"hTpkPVU4pThkM0", consumerSecret:"ovEqziMzLpUOF163Qg2mj")
        
        //For facebook access
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        //INAPP PURCHASE
//        SwiftyStoreKit.restorePurchases(atomically: true, applicationUsername: "Mydateapp") { (values) in
//            print(values.restoredPurchases.count)
//        }
//
//        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
//            for purchase in purchases {
//                switch purchase.transaction.transactionState {
//                case .purchased, .restored:
//                    if purchase.needsFinishTransaction {
//                        // Deliver content from server, then:
//                        SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    }
//                // Unlock content
//                case .failed, .purchasing, .deferred:
//                    break // do nothing
//                }
//            }
//        }
        return true
    }
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //bedgeCountZero()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        // bedgeCountZero()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    //facebookIntegration
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.setValue(token, forKey: "DeviceToken")
        print(token)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
//        NotificationCenter.default.post(name: Notification.Name("ChatNotificationIdentifier"), object: nil)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewControllers = appDelegate.window?.rootViewController?.childViewControllers
        let CurrentView: UIViewController? = viewControllers?.last
        
       // let currentNav = window?.rootViewController?.childViewControllers
        //let CurrentViewArray = currentNav?.viewControllers
        //let CurrentView: UIViewController? = CurrentViewArray?.last
        
        if (CurrentView is MessageViewController) {
            let userInformation = notification.request.content.userInfo
            NotificationCenter.default.post(name: Notification.Name("ChatNotificationIdentifier"), object: userInformation)
        }
        else {
            completionHandler([.sound, .alert, .badge])
        }
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        var dict = response.notification.request.content.userInfo
        let notificationCode = dict["notification_code"] as! Int
        if notificationCode == 2 {
            perform(#selector(self.loadviewforchat), with: dict, afterDelay: 2.0)
        }
        else {
            perform(#selector(self.loadViewForNotifications), with: dict, afterDelay: 2.0)
        }
        print("User Info : \(response.notification.request.content.userInfo)")
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error)
        
    }
    
    //for chat
    func loadviewforchat(_ dict: [AnyHashable: Any]) {
        
        // NSDictionary *chatdict = [dict objectForKey:@"chat"];
        NotificationCenter.default.post(name: NSNotification.Name("loadviewforchat"), object: dict)
    }
    
    //for notifications
    func loadViewForNotifications(_ dict: [AnyHashable: Any]) {
        
        // NSDictionary *chatdict = [dict objectForKey:@"chat"];
        NotificationCenter.default.post(name: NSNotification.Name("loadviewfornotifications"), object: dict)
    }
    
    func bedgeCountZero(){
    }
    
}

