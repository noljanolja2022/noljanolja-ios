//
//  NetworkLoggerPluggin.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

extension NetworkLoggerPlugin {
    static let verboseAndCurl = NetworkLoggerPlugin(configuration: Configuration(logOptions: [.verbose, .formatRequestAscURL]))
}
