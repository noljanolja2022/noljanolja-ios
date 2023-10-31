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

    private let localUserRepository: LocalUserRepository
    private let socketAPI: ConversationSocketAPIType
    private let conversationLocalRepository: ConversationLocalRepository
    private let localDetailConversationRepository: LocalDetailConversationRepository
    private let localMessageRepository: LocalMessageRepository

    init(localUserRepository: LocalUserRepository = LocalUserRepositoryImpl.default,
         socketAPI: ConversationSocketAPIType = ConversationSocketAPI.default,
         conversationLocalRepository: ConversationLocalRepository = ConversationLocalRepositoryImpl.default,
         localDetailConversationRepository: LocalDetailConversationRepository = LocalDetailConversationRepositoryImpl.default,
         localMessageRepository: LocalMessageRepository = LocalMessageRepositoryImpl.default) {
        self.localUserRepository = localUserRepository
        self.socketAPI = socketAPI
        self.conversationLocalRepository = conversationLocalRepository
        self.localDetailConversationRepository = localDetailConversationRepository
        self.localMessageRepository = localMessageRepository
    }

    func register() {
        socketAPI.register()
    }

    private func getStream() -> AnyPublisher<Result<Conversation, Error>, Never> {
        socketAPI.getStream()
            .withLatestFrom(localUserRepository.getCurrentUserPublisher()) { ($0, $1) }
            .handleEvents(receiveOutput: { [weak self] result, currentUser in
                guard let self else { return }
                switch result {
                case let .success(conversation):
                    let lastMessage = conversation.messages.sorted { $0.createdAt > $1.createdAt }.first
                    switch lastMessage?.type {
                    case .eventLeft:
                        if lastMessage?.leftParticipants.map({ $0.id }).contains(currentUser.id) ?? false {
                            self.conversationLocalRepository
                                .removeConversation(conversationID: conversation.id)
                            self.localDetailConversationRepository
                                .removeConversationDetail(conversationID: conversation.id)
                        } else {
                            self.conversationLocalRepository.saveConversations([conversation])
                            self.localDetailConversationRepository.saveConversationDetails([conversation])
                        }
                    case .plaintext, .photo, .sticker, .eventUpdated, .eventJoined, .unknown, .none:
                        self.conversationLocalRepository.saveConversations([conversation])
                        self.localDetailConversationRepository.saveConversationDetails([conversation])
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
                    self?.localMessageRepository.saveMessages([lastMessage])
                case .failure:
                    break
                }
            })
            .eraseToAnyPublisher()
    }
}
