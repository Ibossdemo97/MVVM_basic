//
//  AppDelegate.swift
//  MVVM_Combine
//
//  Created by Nhấc tay khỏi Mac của tao on 15/5/24.
//

import UIKit
import Sentry



@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SentrySDK.start { options in
                options.dsn = "https://b4107a1592c84f4798f832157db6e8ba@sentry.vtvlive.vn/14"
                options.debug = true
                        options.enableAutoSessionTracking = true
                        options.enableCrashHandler = true

                        
                options.tracesSampleRate = 1.0
            }

        SentrySDK.capture(message: "luyentestCrash")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

