//
//  AppDelegate.swift
//  TrampolineJumpSwift
//
//  Created by App Developer on 11/02/2015.
//  Copyright (c) 2015 App Developer. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ChartboostDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let kChartboostAppID = "55e26d32c909a60956897482";
        let kChartboostAppSignature = "3679cf605989fd2aef9e31f5b3c2d881e3d78797";
        
        Chartboost.startWithAppId(kChartboostAppID, appSignature: kChartboostAppSignature, delegate: self);
        Chartboost.cacheMoreApps(CBLocationHomeScreen)
        
        GCHelper.sharedInstance.authenticateLocalUser()
        
        return true
        


    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        if let view = window?.rootViewController?.view as? SKView {
            
            view.scene?.paused = true
            
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if let view = window?.rootViewController?.view as? SKView {
        
        view.scene?.paused = true
    }
    
    }
    

    
    class func showChartboostAds()
    {
        
        println("called chartboost")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var unlocked = defaults.boolForKey("unlockedKey")
        println("\(unlocked)")

        if !unlocked{
            
          //  Chartboost.showInterstitial(CBLocationHomeScreen);
        }
        
        
    }
    
    func didFailToLoadInterstitial(error: CBLoadError)
    {
        println("Chartboost FAIL")

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

