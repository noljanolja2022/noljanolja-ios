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

// MARK: - AuthStore + AuthRepo

extension AuthStore: AuthRepo {
    func getAuthToken() async throws -> String? {
        getToken()
    }
}

// MARK: - ConversationSocketServiceType

protocol ConversationSocketServiceType {
    func streamConversations()
}

// MARK: - ConversationSocketService

final class ConversationSocketService: ConversationSocketServiceType {
    static let `default` = ConversationSocketService()
    
    private let conversationSocket: ConversationSocket
    private let conversationStore: ConversationStoreType
    private let conversationDetailStore: ConversationDetailStoreType

    private var cancellables = Set<AnyCancellable>()

    private init(authRepo: AuthRepo = AuthStore.default,
                 conversationStore: ConversationStoreType = ConversationStore.default,
                 conversationDetailStore: ConversationDetailStoreType = ConversationDetailStore.default) {
        self.conversationSocket = ConversationSocket(rsocketUrl: "ws://34.64.110.104/rsocket", authRepo: AuthStore.default)
        self.conversationStore = conversationStore
        self.conversationDetailStore = conversationDetailStore
    }

    func streamConversations() {
        let streamConversations = conversationSocket.streamConversations()
        let streamConversationsPublisher = createPublisher(for: streamConversations)

        streamConversationsPublisher
            .compactMap { string in
                let data = string.data(using: .utf8)
                return data.flatMap { Conversation(from: $0) }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] conversation in
                    self?.conversationStore.saveConversations([conversation])
                    self?.conversationDetailStore.saveMessages(conversation.messages)
                }
            )
            .store(in: &cancellables)
    }
}
