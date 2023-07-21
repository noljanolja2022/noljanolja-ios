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
import IQKeyboardManagerSwift
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin
import SDWebImage
import SDWebImageWebPCoder
import UIKit

// MARK: - FrameworkAppDelegate

final class FrameworkAppDelegate: NSObject, AppDelegateProtocol {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        configureIQKeyboard()
        configureSDWebImage()
        configureAuth()
        configureFirebase()

        return true
    }
}

extension FrameworkAppDelegate {
    private func configureIQKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

    private func configureSDWebImage() {
        let requestModifier: (URLRequest) -> URLRequest? = { request -> URLRequest? in
            var request = request
            let baseUrl = URL(string: NetworkConfigs.BaseUrl.baseUrl)
            if request.url?.host == baseUrl?.host {
                if let token = AuthStore.default.getToken() {
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
            }
            return request
        }

        SDWebImageDownloader.shared.requestModifier = SDWebImageDownloaderRequestModifier(block: requestModifier)

        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)

        // Dynamic check to support vector format for both WebImage/AnimatedImage
        SDWebImageManager.shared.optionsProcessor = SDWebImageOptionsProcessor { _, options, context in
            var options = options
            if let _ = context?[.animatedImageClass] as? SDAnimatedImage.Type {
                // AnimatedImage supports vector rendering, should not force decode
                options.insert(.avoidDecodeImage)
            }
            return SDWebImageOptionsResult(options: options, context: context)
        }
    }

    private func configureAuth() {
        KakaoSDK.initSDK(appKey: AppConfigs.SDK.Kakao.nativeAppKey)

        let naverLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLoginConnection?.isNaverAppOauthEnable = true
        naverLoginConnection?.isInAppOauthEnable = true
        naverLoginConnection?.setOnlyPortraitSupportInIphone(true)

        naverLoginConnection?.serviceUrlScheme = AppConfigs.SDK.Naver.serviceUrlScheme
        naverLoginConnection?.consumerKey = AppConfigs.SDK.Naver.consumerKey
        naverLoginConnection?.consumerSecret = AppConfigs.SDK.Naver.consumerSecret
        naverLoginConnection?.appName = AppConfigs.SDK.Naver.appName
    }

    private func configureFirebase() {
        FirebaseApp.configure()
    }
}
