//
//  NetworkConfig.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation

enum NetworkConfigs {
    static let baseUrl = "http://34.64.110.104/api"

    enum Format {
        static let apiDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let apiDateFormats = ["yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ"]
    }
}
