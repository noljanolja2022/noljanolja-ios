//
//  NetworkConfig.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation

enum NetworkConfigs {
    enum BaseUrl {
        static let baseUrl = Natrium.Config.baseUrl
        static let socketBaseUrl = Natrium.Config.socketBaseUrl
    }

    enum Format {
        static let apiDateFormat = "yyyy-MM-dd"
        static let apiFullDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let apiFullDateFormats = ["yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ"]
    }

    enum Param {
        static let firstPage = 1
    }
}
