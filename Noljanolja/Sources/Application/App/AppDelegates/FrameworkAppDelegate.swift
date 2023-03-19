//
//  FrameworkAppDelegate.swift
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

final class FrameworkAppDelegate: NSObject, AppDelegateProtocol {
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
}
