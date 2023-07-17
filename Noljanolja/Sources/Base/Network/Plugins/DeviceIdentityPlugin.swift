//
//  DeviceIdentityPlugin.swift
//  VinID
//
//  Created by Khoi Truong Minh on 10/13/18.
//  Copyright © 2018 vinid. All rights reserved.
//

import Foundation
import Moya
import UIKit

public struct DeviceIdentityPlugin: PluginType {
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    private let systemVersion = UIDevice.current.systemVersion
    private let deviceName = UIDevice.current.name

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request

        let value = "noljanolja/\(appVersion) (Mobile; iOS \(systemVersion); \(deviceName))"
        request.addValue(value, forHTTPHeaderField: "User-Agent")
        return request
    }
}
