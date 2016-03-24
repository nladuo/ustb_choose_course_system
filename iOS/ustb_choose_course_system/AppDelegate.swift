//
//  AppDelegate.swift
//  ustb_choose_course_system
//
//  Created by kalen blue on 15-8-9.
//  Copyright (c) 2015年 kalen blue. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchedShortcutItem: UIApplicationShortcutItem?
    
    enum ShortcutIdentifier: String {
        
        case First
        
        init?(fullType: String) {
            guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
        var type: String {
            return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
        }
        
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var handled = false
        
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        switch (shortCutType) {
        case ShortcutIdentifier.First.type:
            // Handle shortcut 1
            var cList:[String] = []
            var tempStr:String = ""
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let class_list:AnyObject = userDefaults.objectForKey("class_list"){
                tempStr = class_list as! String
                cList = tempStr.componentsSeparatedByString("\n")
            }
            
            if (cList.count == 0) || (tempStr == ""){
                let alert = UIAlertView(title: "提示", message: "你还没有添加本地课表，请登陆后添加", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                return true
            }
            var vc = LocalClassTableViewController()
            vc = storyboard.instantiateViewControllerWithIdentifier("LocalClassTableVC") as! LocalClassTableViewController
            vc.cList = []
            for str in cList{
                if str != ""{
                    vc.cList.append(str)
                }
            }
            print("Hello")
            let navGC = window!.rootViewController as? UINavigationController
            navGC?.pushViewController(vc, animated: true)
            print("dasdasda")
            handled = true
            break
        default:
            break
        }
        
        return handled
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            launchedShortcutItem = shortcutItem
        }
        
        return true
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        guard let shortcut = launchedShortcutItem else { return }
        
        handleShortCutItem(shortcut)
        launchedShortcutItem = nil
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

