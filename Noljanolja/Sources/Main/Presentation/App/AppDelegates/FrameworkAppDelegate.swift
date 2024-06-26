//
//  FrameworkAppDelegate.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import AVKit
import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleMobileAds
import GoogleSignIn
import IQKeyboardManagerSwift
import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin
import SDWebImage
import SDWebImageWebPCoder
import UIKit

// MARK: - FrameworkAppDelegate

final class FrameworkAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        configureAudioSesion()
        configureIQKeyboard()
        configureSDWebImage()
        configureAuth()
        configureFirebase()
        configureGoogleAds()

        return true
    }
}

extension FrameworkAppDelegate {
    private func configureAudioSesion() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        } catch {
            print("Failed to set audioSession category to playback")
        }
    }

    private func configureIQKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

    private func configureSDWebImage() {
        let requestModifier: (URLRequest) -> URLRequest? = { request -> URLRequest? in
            var request = request
            let baseUrl = URL(string: NetworkConfigs.BaseUrl.baseUrl)
            if request.url?.host == baseUrl?.host {
                if let token = AuthLocalRepositoryImpl.default.getToken() {
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
    
    private func configureGoogleAds() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = AdMobConfigs.TestDevice.testDevices
    }
}
