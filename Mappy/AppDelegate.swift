//
//  AppDelegate.swift
//  Mappy
//
//  Created by Erik Jälevik on 23/07/15.
//  Copyright (c) 2015 Futurice. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?


    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
            -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        window!.rootViewController = RootController()
        window!.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(application: UIApplication)
    {
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
    }

    func applicationWillTerminate(application: UIApplication)
    {
    }

}

