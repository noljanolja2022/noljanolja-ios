//
//  NetworkConfig.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation

enum NetworkConfigs {
    enum BaseUrl {
        static let baseUrl = "http://dev.consumer-service.ppnyy.com/api"
        static let socketBaseUrl = "ws://34.64.110.104/rsocket"
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
