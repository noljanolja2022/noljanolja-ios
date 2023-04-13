//
//  ConversationService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Combine
import Foundation

// MARK: - ConversationServiceType

protocol ConversationServiceType {
    func getConversations() -> AnyPublisher<[Conversation], Error>
    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error>

    func createConversation(type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error>

    func updateConversation(conversationID: Int,
                            title: String?,
                            participants: [User]?,
                            image: Data?) -> AnyPublisher<Conversation, Error>

    func addParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Conversation, Error>
    func removeParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Conversation, Error>
    func assignAdmin(conversationID: Int, admin: User) -> AnyPublisher<Conversation, Error>
}

extension ConversationServiceType {
    func updateConversation(conversationID: Int,
                            title: String? = nil,
                            participants: [User]? = nil,
                            image: Data? = nil) -> AnyPublisher<Conversation, Error> {
        updateConversation(
            conversationID: conversationID,
            title: title,
            participants: participants,
            image: image
        )
    }
}

// MARK: - ConversationService

final class ConversationService: ConversationServiceType {
    static let `default` = ConversationService()

    private let conversationAPI: ConversationAPIType
    private let conversationParticipantAPI: ConversationParticipantAPIType
    private let conversationStore: ConversationStoreType
    private let conversationDetailStore: ConversationDetailStoreType
    private let userService: UserServiceType

    private init(conversationAPI: ConversationAPIType = ConversationAPI.default,
                 conversationParticipantAPI: ConversationParticipantAPIType = ConversationParticipantAPI.default,
                 conversationStore: ConversationStoreType = ConversationStore.default,
                 conversationDetailStore: ConversationDetailStoreType = ConversationDetailStore.default,
                 userService: UserServiceType = UserService.default) {
        self.conversationAPI = conversationAPI
        self.conversationParticipantAPI = conversationParticipantAPI
        self.conversationStore = conversationStore
        self.conversationDetailStore = conversationDetailStore
        self.userService = userService
    }

    func getConversations() -> AnyPublisher<[Conversation], Error> {
        let localConversations = conversationStore
            .observeConversations()
            .filter { !$0.isEmpty }

        let remoteConversations = conversationAPI
            .getConversations()
            .handleEvents(receiveOutput: { [weak self] conversations in
                self?.conversationStore.saveConversations(conversations)
                self?.conversationStore.removeConversation(notIn: conversations)
            })

        return Publishers.Merge(localConversations, remoteConversations)
            .map { conversations in
                conversations
                    .map {
                        Conversation(
                            id: $0.id,
                            title: $0.title,
                            creator: $0.creator,
                            admin: $0.admin,
                            type: $0.type,
                            messages: $0.messages.sorted { $0.createdAt > $1.createdAt },
                            participants: $0.participants,
                            createdAt: $0.createdAt,
                            updatedAt: $0.updatedAt
                        )
                    }
                    //                    .sorted { $0.updatedAt > $1.updatedAt }
                    .sorted { lhs, rhs in
                        let lhsLastMessage = lhs.messages.first
                        let rhsLastMessage = rhs.messages.first
                        if let lhsLastMessage, let rhsLastMessage {
                            return lhsLastMessage.createdAt > rhsLastMessage.createdAt
                        } else if lhsLastMessage != nil {
                            return true
                        } else if rhsLastMessage != nil {
                            return false
                        } else {
                            return lhs.createdAt > rhs.createdAt
                        }
                    }
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func getConversation(conversationID: Int) -> AnyPublisher<Conversation, Error> {
        let localConversation = conversationDetailStore
            .observeConversationDetail(conversationID: conversationID)
        let remoteConversation = conversationAPI
            .getConversation(conversationID: conversationID)
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationDetailStore.saveConversationDetails([$0])
            })
        return Publishers.Merge(localConversation, remoteConversation)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func createConversation(type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error> {
        if participants.count == 1,
           let currentUser = userService.currentUser,
           let conversation = conversationStore.getConversations(
               type: .single,
               participants: participants + [currentUser]
           ).first {
            return Just(conversation)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return conversationAPI
                .createConversation(title: "", type: type, participants: participants)
                .handleEvents(receiveOutput: { [weak self] in
                    self?.conversationDetailStore.saveConversationDetails([$0])
                })
                .eraseToAnyPublisher()
        }
    }

    func updateConversation(conversationID: Int,
                            title: String?,
                            participants: [User]?,
                            image: Data?) -> AnyPublisher<Conversation, Error> {
        conversationAPI
            .updateConversation(
                conversationID: conversationID,
                title: title,
                participants: participants,
                image: image
            )
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationDetailStore.saveConversationDetails([$0])
            })
            .eraseToAnyPublisher()
    }

    func addParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Conversation, Error> {
        conversationParticipantAPI
            .addParticipant(conversationID: conversationID, participants: participants)
            .flatMap { [weak self] in
                guard let self else { return Empty<Conversation, Error>().eraseToAnyPublisher() }
                return self.conversationAPI.getConversation(conversationID: conversationID)
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationDetailStore.saveConversationDetails([$0])
            })
            .eraseToAnyPublisher()
    }

    func removeParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Conversation, Error> {
        conversationParticipantAPI
            .removeParticipant(conversationID: conversationID, participants: participants)
            .flatMap { [weak self] in
                guard let self else { return Empty<Conversation, Error>().eraseToAnyPublisher() }
                return self.conversationAPI.getConversation(conversationID: conversationID)
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationDetailStore.saveConversationDetails([$0])
            })
            .eraseToAnyPublisher()
    }

    func assignAdmin(conversationID: Int, admin: User) -> AnyPublisher<Conversation, Error> {
        conversationParticipantAPI
            .assignAdmin(conversationID: conversationID, admin: admin)
            .flatMap { [weak self] in
                guard let self else { return Empty<Conversation, Error>().eraseToAnyPublisher() }
                return self.conversationAPI.getConversation(conversationID: conversationID)
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.conversationDetailStore.saveConversationDetails([$0])
            })
            .eraseToAnyPublisher()
    }
}
