//
//  AuthConfigAppDelegate.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin
import UIKit

// MARK: - AppDelegate

final class AuthAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Auth.auth().canHandle(url)
            || GIDSignIn.sharedInstance.handle(url)
            || (AuthApi.isKakaoTalkLoginUrl(url) && AuthController.handleOpenUrl(url: url))
            || NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)

        // Further handling of the device token if needed by the app
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
        // This notification is not auth related; it should be handled separately.
    }
}
