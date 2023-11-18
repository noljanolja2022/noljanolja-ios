//
//  RemoteConfigRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/11/2023.
//

import Combine
import FirebaseRemoteConfig
import Foundation

// MARK: - RemoteConfigRepository

protocol RemoteConfigRepository {
    func get() -> Future<RemoteConfigModel, Error>
}

// MARK: - RemoteConfigRepositoryImpl

final class RemoteConfigRepositoryImpl: RemoteConfigRepository {
    static let shared: RemoteConfigRepository = RemoteConfigRepositoryImpl()
    
    func get() -> Future<RemoteConfigModel, Error> {
        Future { promise in
            let remoteConfig = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig.configSettings = settings
            
            remoteConfig.fetch { status, error in
                if let error {
                    promise(.failure(error))
                } else if .success != status {
                    promise(.failure(CommonError.unknown))
                } else {
                    remoteConfig.activate { _, error in
                        if let error {
                            promise(.failure(error))
                        } else {
                            let remoteConfigModel = RemoteConfigModel(remoteConfig: remoteConfig)
                            promise(.success(remoteConfigModel))
                        }
                    }
                }
            }
        }
    }
}

extension RemoteConfigModel {
    init(remoteConfig: RemoteConfig) {
        self.isLoginEmailPasswordEnabled = remoteConfig.configValue(forKey: "login_email_password").boolValue
        self.isLoginAppleEnabled = remoteConfig.configValue(forKey: "login_apple").boolValue
    }
}
