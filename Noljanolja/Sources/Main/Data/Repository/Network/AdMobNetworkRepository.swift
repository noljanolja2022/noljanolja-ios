//
//  AdMobNetworkRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/10/2023.
//

import Combine
import Foundation
import GoogleMobileAds

// MARK: - AdMobConfigs

enum AdMobConfigs {
    fileprivate enum AdUnitIds {
        static var rewardedAd: String {
            switch Natrium.Config.environment {
            case .development: return "ca-app-pub-3940256099942544/1712485313"
            case .production: return "ca-app-pub-1290059557536284/6691193591"
            }
        }
    }
    
    enum TestDevice {
        static var testDevices: [String]? {
            switch Natrium.Config.environment {
            case .development: return []
            case .production: return []
            }
        }
    }
}

// MARK: - AdMobNetworkRepository

protocol AdMobNetworkRepository {
    func loadRewardedAd() -> Future<GADRewardedAd, Error>
}

// MARK: - AdMobNetworkRepositoryImpl

final class AdMobNetworkRepositoryImpl: AdMobNetworkRepository {
    static let shared: AdMobNetworkRepository = AdMobNetworkRepositoryImpl()
    
    func loadRewardedAd() -> Future<GADRewardedAd, Error> {
        Future { promise in
            let request = GADRequest()
            GADRewardedAd.load(withAdUnitID: AdMobConfigs.AdUnitIds.rewardedAd, request: request) { ad, error in
                if let error {
                    promise(.failure(error))
                    return
                }
                guard let ad else {
                    promise(.failure(CommonError.informationNotFound(message: "Ad not found")))
                    return
                }
                promise(.success(ad))
            }
        }
    }
}
