//
//  ApiProvider.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

final class ApiProvider: MoyaProvider<MultiTarget> {
    static let `default` = ApiProvider()

    private static let defaultPlugins: [PluginType] = {
        [
            NetworkLoggerPlugin.verboseAndCurl,
            DisableLocalCachePlugin(),
            RequestTimeoutPlugin(),
            AuthorizationPluggin()
        ]
    }()

    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider<MultiTarget>.defaultEndpointMapping,
                  requestClosure: @escaping RequestClosure = MoyaProvider<MultiTarget>.defaultRequestMapping,
                  stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
                  plugins: [PluginType] = defaultPlugins,
                  trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
}
