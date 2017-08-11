//
//  AppDelegate.swift
//  FBMeUser
//
//  Created by pike young on 2017/8/10.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: FBMeViewController())
        window?.makeKeyAndVisible()
        
        return true
    }
}

