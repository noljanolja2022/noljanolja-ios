//
//  NoljanoljaApp.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import _SwiftUINavigationState
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import Introspect
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin
import SwifterSwift
import SwiftUI
import SwiftUINavigation

// MARK: - AppDelegate

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        KakaoSDK.initSDK(appKey: AppConfigs.SDK.Kakao.nativeAppKey)

        let naverLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLoginConnection?.isNaverAppOauthEnable = true
        naverLoginConnection?.isInAppOauthEnable = true
        naverLoginConnection?.setOnlyPortraitSupportInIphone(true)

        naverLoginConnection?.serviceUrlScheme = AppConfigs.SDK.Naver.serviceUrlScheme
        naverLoginConnection?.consumerKey = AppConfigs.SDK.Naver.consumerKey
        naverLoginConnection?.consumerSecret = AppConfigs.SDK.Naver.consumerSecret
        naverLoginConnection?.appName = AppConfigs.SDK.Naver.appName

        FirebaseApp.configure()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Auth.auth().canHandle(url)
            || GIDSignIn.sharedInstance.handle(url)
            || (AuthApi.isKakaoTalkLoginUrl(url) && AuthController.handleOpenUrl(url: url))
            || NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
    }
}

// MARK: - NoljanoljaApp

@main
struct NoljanoljaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
