//
//  ConversationSocketService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/04/2023.
//

import Combine
import Foundation

// MARK: - ConversationSocketServiceType

protocol ConversationSocketServiceType {
    func register()
    func getConversationStream() -> AnyPublisher<Result<Conversation, Error>, Never>
    func getConversationStream(id: Int) -> AnyPublisher<Result<Conversation, Error>, Never>
}

// MARK: - ConversationSocketService

final class ConversationSocketService: ConversationSocketServiceType {
    static let `default` = ConversationSocketService()

    private let userStore: UserStoreType
    private let socketAPI: ConversationSocketAPIType
    private let conversationStore: ConversationStoreType
    private let conversationDetailStore: ConversationDetailStoreType
    private let messageStore: MessageStoreType

    init(userStore: UserStoreType = UserStore.default,
         socketAPI: ConversationSocketAPIType = ConversationSocketAPI.default,
         conversationStore: ConversationStoreType = ConversationStore.default,
         conversationDetailStore: ConversationDetailStoreType = ConversationDetailStore.default,
         messageStore: MessageStoreType = MessageStore.default) {
        self.userStore = userStore
        self.socketAPI = socketAPI
        self.conversationStore = conversationStore
        self.conversationDetailStore = conversationDetailStore
        self.messageStore = messageStore
    }

    func register() {
        socketAPI.register()
    }

    private func getStream() -> AnyPublisher<Result<Conversation, Error>, Never> {
        socketAPI.getStream()
            .withLatestFrom(userStore.getCurrentUserPublisher()) { ($0, $1) }
            .handleEvents(receiveOutput: { [weak self] result, currentUser in
                guard let self else { return }
                switch result {
                case let .success(conversation):
                    let lastMessage = conversation.messages.sorted { $0.createdAt > $1.createdAt }.first
                    switch lastMessage?.type {
                    case .eventLeft:
                        if lastMessage?.leftParticipants.map({ $0.id }).contains(currentUser.id) ?? false {
                            self.conversationStore
                                .removeConversation(conversationID: conversation.id)
                            self.conversationDetailStore
                                .removeConversationDetail(conversationID: conversation.id)
                        } else {
                            self.conversationStore.saveConversations([conversation])
                            self.conversationDetailStore.saveConversationDetails([conversation])
                        }
                    case .plaintext, .photo, .sticker, .eventUpdated, .eventJoined, .unknown, .none:
                        self.conversationStore.saveConversations([conversation])
                        self.conversationDetailStore.saveConversationDetails([conversation])
                    }
                case .failure:
                    return
                }
            })
            .map { result, _ in result }
            .eraseToAnyPublisher()
    }

    func getConversationStream() -> AnyPublisher<Result<Conversation, Error>, Never> {
        getStream()
            .eraseToAnyPublisher()
    }

    func getConversationStream(id: Int) -> AnyPublisher<Result<Conversation, Error>, Never> {
        getStream()
            .filter { result in
                switch result {
                case let .success(conversation):
                    return conversation.id == id
                case .failure:
                    return false
                }
            }
            .receive(on: DispatchQueue.main) // NOTED: Do on serial queue to wait write then read
            .handleEvents(receiveOutput: { [weak self] result in
                switch result {
                case let .success(conversation):
                    let sortedMessages = conversation.messages.sorted { $0.createdAt > $1.createdAt }
                    guard let lastMessage = sortedMessages.first else { return }
                    self?.messageStore.saveMessages([lastMessage])
                case .failure:
                    break
                }
            })
            .eraseToAnyPublisher()
    }
}
