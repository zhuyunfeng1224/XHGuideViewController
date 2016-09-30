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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let vc1: XHGuideContentViewController = XHGuideContentViewController(imageNameOrUrl: "1.jpg", imageType: .system, buttonTitle: nil)
        vc1.imageView.contentMode = .scaleAspectFit
        
        vc1.tapAtIndex = {(index: Int) in
            print("tap at index:\(index)")
        }
        let vc2: XHGuideContentViewController = XHGuideContentViewController(imageNameOrUrl: "2.jpg", imageType: .system, buttonTitle: nil)
        vc2.imageView.contentMode = .scaleAspectFit
        vc2.tapAtIndex = {(index: Int) in
            print("tap at index:\(index)")
        }
        
        let vc3: XHGuideContentViewController = XHGuideContentViewController(imageNameOrUrl: "3.jpg", imageType: .system, buttonTitle: nil)
        vc3.imageView.contentMode = .scaleAspectFit
        vc3.tapAtIndex = {(index: Int) in
            print("tap at index:\(index)")
        }
        
        let guideVC: XHGuideViewController = XHGuideViewController()
        guideVC.viewControllers = [vc1, vc2, vc3]
        guideVC.autoClose = true
        guideVC.showSkipButton = true
        guideVC.backgroundImageView.image = UIImage(named: "bg.jpg")
        guideVC.backgroundImageView.alpha = 0.3
        guideVC.showTime = 30
        guideVC.actionSkip = {
            let vc: ViewController = ViewController()
            vc.modalTransitionStyle = .crossDissolve
            guideVC.present(vc, animated: true, completion: nil)
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = guideVC
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

