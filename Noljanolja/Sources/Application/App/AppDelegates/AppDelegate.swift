//
//  AppDelegate.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/03/2023.
//

import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var appDelegates: [AppDelegateProtocol] = [FrameworkAppDelegate(), AuthAppDelegate(), NotificationAppDelegate()]

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        appDelegates
            .map { appDelegate in
                appDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
            }
            .reduce(true) { $0 && $1 }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appDelegates
            .forEach { appDelegate in
                appDelegate.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
            }
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        appDelegates
            .forEach { appDelegate in
                appDelegate.application(application, didReceiveRemoteNotification: notification, fetchCompletionHandler: completionHandler)
            }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        appDelegates
            .map { appDelegate in
                appDelegate.application(app, open: url, options: options)
            }
            .reduce(false) { $0 || $1 }
    }
}
