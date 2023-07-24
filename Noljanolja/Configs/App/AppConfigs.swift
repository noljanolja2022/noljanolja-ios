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
            static let nativeAppKey = "15d1b0d5dde51ea18a397effc5f25e3c" // TODO: Update Auth - Kakao - Update URLSchemes on Info.plist (kakaofeccad35483064ee33942819974a1d11)
        }

        enum Naver {
            // TODO: Update Auth - Naver - Update string here
            static let serviceUrlScheme = "com.noljanolja.app.ios" // TODO: Update Auth - Kakao - Update URLSchemes on Info.plist (noljanolja)
            static let consumerKey = "3zDg6vMsJmoFk2TGOjcq"
            static let consumerSecret = "8keRny2c_4"
            static let appName = "놀구벌구"
        }
    }

    enum App {
        static let customerServiceCenter = "1588-1588"
    }
}
