//
//  VideoSocketAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//

import Combine
import Foundation
import KMPNativeCoroutinesCombine
import shared

// MARK: - VideoSocketAPIType

protocol VideoSocketAPIType {
    func trackVideoProgress(data: String)
}

// MARK: - VideoSocketAPI

final class VideoSocketAPI: VideoSocketAPIType {
    static let `default` = VideoSocketAPI()

    private let socket: VideoSocket

    private var cancellable: AnyCancellable?

    private init(rsocketUrl: String = NetworkConfigs.BaseUrl.socketBaseUrl,
                 authRepo: AuthRepo = AuthStore.default) {
        self.socket = VideoSocket(
            rsocketUrl: rsocketUrl,
            authRepo: authRepo
        )
    }

    func trackVideoProgress(data: String) {
        let future = createFuture(for: socket.trackVideoProgress(data: data))
        cancellable = future
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
    }
}
