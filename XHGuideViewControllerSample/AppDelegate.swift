//
//  AppDelegate.swift
//  XHGuideViewController
//
//  Created by echo on 16/7/26.
//  Copyright © 2016年 羲和. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let guideVC: XHGuideViewController = XHGuideViewController()
        let vc1: XHGuideContentViewController = XHGuideContentViewController(imageNameOrUrl: "1.jpg", imageType: .System, buttonTitle: nil)
        
        vc1.tapAtIndex = {(index: Int) in
            print("tap at index:\(index)")
        }
        let vc2: XHGuideContentViewController = XHGuideContentViewController(imageNameOrUrl: "2.jpg", imageType: .System, buttonTitle: nil)
        vc2.tapAtIndex = {(index: Int) in
            print("tap at index:\(index)")
        }
        
        let vc3: XHGuideContentViewController = XHGuideContentViewController(imageNameOrUrl: "3.jpg", imageType: .System, buttonTitle: nil)
        vc3.tapAtIndex = {(index: Int) in
            print("tap at index:\(index)")
        }
        guideVC.viewControllers = [vc1, vc2, vc3]
        guideVC.autoClose = false
        guideVC.showSkipButton = false
        guideVC.backgroundImageView.image = UIImage(named: "bg.jpg")
        guideVC.backgroundImageView.alpha = 0.3
        guideVC.actionSkip = {
            let vc: ViewController = ViewController()
            vc.modalTransitionStyle = .CrossDissolve
            guideVC.presentViewController(vc, animated: true, completion: nil)
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController = guideVC
        self.window?.makeKeyAndVisible()
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

