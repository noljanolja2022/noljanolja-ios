//
//  AppConfigs.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Foundation

enum AppConfigs {
    enum SDK {
        enum Kakao {
            // TODO: Update Auth - Kakao - Update appp key here
            static let nativeAppKey = "feccad35483064ee33942819974a1d11" // TODO: Update Auth - Kakao - Update URLSchemes on Info.plist (kakaofeccad35483064ee33942819974a1d11)
        }

        enum Naver {
            // TODO: Update Auth - Naver - Update string here
            static let serviceUrlScheme = "noljanolja" // TODO: Update Auth - Kakao - Update URLSchemes on Info.plist (noljanolja)
            static let consumerKey = "2z1UFB1yrf_wQjDS7_jN"
            static let consumerSecret = "_30MLs3qfo"
            static let appName = "Noljanolja-Test"
        }
    }
}
