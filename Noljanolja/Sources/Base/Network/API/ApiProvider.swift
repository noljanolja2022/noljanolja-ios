//
//  ApiProvider.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import Foundation
import Moya

// MARK: - ApiProvider

final class ApiProvider: MoyaProvider<MultiTarget> {
    static let `default` = ApiProvider()

    private static let defaultPlugins: [PluginType] = {
        [
            NetworkLoggerPlugin.verboseAndCurl,
            DisableLocalCachePlugin(),
            RequestTimeoutPlugin(),
            DeviceIdentityPlugin(),
            AuthPluggin()
        ]
    }()

    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider<MultiTarget>.defaultEndpointMapping,
                  requestClosure: @escaping RequestClosure = MoyaProvider<MultiTarget>.defaultRequestMapping,
                  stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  session: Session = Session(interceptor: RefreshTokenInterceptor()),
                  plugins: [PluginType] = defaultPlugins,
                  trackInflights: Bool = false) {
        super.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
}
