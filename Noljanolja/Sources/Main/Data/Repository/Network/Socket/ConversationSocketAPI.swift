//
//  ConversationSocketService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/03/2023.
//

import Combine
import Foundation
import KMPNativeCoroutinesCombine
import shared

// MARK: - ConversationSocketAPIType

protocol ConversationSocketAPIType {
    func register()
    func getStream() -> AnyPublisher<Result<Conversation, Error>, Never>
}

// MARK: - ConversationSocketAPI

final class ConversationSocketAPI: ConversationSocketAPIType {
    static let `default` = ConversationSocketAPI()
    
    private let socket: ConversationSocket

    private let streamSubject = PassthroughSubject<Result<Conversation, Error>, Never>()

    private var cancellables = Set<AnyCancellable>()

    private init(rsocketUrl: String = NetworkConfigs.BaseUrl.socketBaseUrl,
                 authRepo: AuthRepo = AuthLocalRepositoryImpl.default) {
        self.socket = ConversationSocket(
            rsocketUrl: rsocketUrl,
            authRepo: authRepo
        )
    }

    func register() {
        let stream = socket.streamConversations()
        let streamPublisher = createPublisher(for: stream)

        streamPublisher
            .compactMap { string in
                let data = string.data(using: .utf8)
                return data.flatMap { Conversation(from: $0) }
            }
            .retry(3)
            .removeDuplicates()
            .mapToResult()
            .subscribe(streamSubject)
            .store(in: &cancellables)
    }

    func getStream() -> AnyPublisher<Result<Conversation, Error>, Never> {
        streamSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
