//
//  NoljanoljaApp.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import FirebaseCore
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

// MARK: - AppDelegate

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        KakaoSDK.initSDK(appKey: AppConfigs.SDK.kakaoNativeAppKey)
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }

        return false
    }
}

// MARK: - NoljanoljaApp

@main
struct NoljanoljaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
