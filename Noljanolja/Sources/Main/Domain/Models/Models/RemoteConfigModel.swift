//
//  RemoteConfig.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 17/11/2023.
//

import Foundation

struct RemoteConfigModel {
    static let `default` = RemoteConfigModel(isLoginEmailPasswordEnabled: false, isLoginAppleEnabled: false)
    
    let isLoginEmailPasswordEnabled: Bool
    let isLoginAppleEnabled: Bool
}
