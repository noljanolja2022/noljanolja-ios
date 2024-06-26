//
//  ConversationUseCasesImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Combine
import Foundation

// MARK: - ConversationUseCases

protocol ConversationUseCases {
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
    func leave(conversationID: Int) -> AnyPublisher<Conversation, Error>
}

extension ConversationUseCases {
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

// MARK: - ConversationUseCasesImpl

final class ConversationUseCasesImpl: ConversationUseCases {
    static let `default` = ConversationUseCasesImpl()

    private let conversationNetworkRepository: ConversationNetworkRepository
    private let conversationParticipantNetworkRepository: ConversationParticipantNetworkRepository
    private let conversationLocalRepository: ConversationLocalRepository
    private let detailConversationLocalRepository: DetailConversationLocalRepository
    private let userLocalRepository: UserLocalRepository

    private init(conversationNetworkRepository: ConversationNetworkRepository = ConversationNetworkRepositoryImpl.default,
                 conversationParticipantNetworkRepository: ConversationParticipantNetworkRepository = ConversationParticipantNetworkRepositoryImpl.default,
                 conversationLocalRepository: ConversationLocalRepository = ConversationLocalRepositoryImpl.default,
                 detailConversationLocalRepository: DetailConversationLocalRepository = DetailConversationLocalRepositoryImpl.default,
                 userLocalRepository: UserLocalRepository = UserLocalRepositoryImpl.default) {
        self.conversationNetworkRepository = conversationNetworkRepository
        self.conversationParticipantNetworkRepository = conversationParticipantNetworkRepository
        self.conversationLocalRepository = conversationLocalRepository
        self.detailConversationLocalRepository = detailConversationLocalRepository
        self.userLocalRepository = userLocalRepository
    }

    func getConversations() -> AnyPublisher<[Conversation], Error> {
        let localConversations = conversationLocalRepository
            .observeConversations()
            .filter { !$0.isEmpty }

        let remoteConversations = conversationNetworkRepository
            .getConversations()
            .handleEvents(receiveOutput: { [weak self] conversations in
                self?.conversationLocalRepository.saveConversations(conversations)
                self?.conversationLocalRepository.removeConversation(notIn: conversations)
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
        let localConversation = detailConversationLocalRepository
            .observeConversationDetail(conversationID: conversationID)
        let remoteConversation = conversationNetworkRepository
            .getConversation(conversationID: conversationID)
            .handleEvents(receiveOutput: { [weak self] in
                self?.detailConversationLocalRepository.saveConversationDetails([$0])
            })
        return Publishers.Merge(localConversation, remoteConversation)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func createConversation(type: ConversationType,
                            participants: [User]) -> AnyPublisher<Conversation, Error> {
        if participants.count == 1,
           let currentUser = userLocalRepository.getCurrentUser(),
           let conversation = conversationLocalRepository.getConversations(
               type: .single,
               participants: participants + [currentUser]
           ).first {
            return Just(conversation)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return conversationNetworkRepository
                .createConversation(title: "", type: type, participants: participants)
                .handleEvents(receiveOutput: { [weak self] in
                    self?.detailConversationLocalRepository.saveConversationDetails([$0])
                })
                .eraseToAnyPublisher()
        }
    }

    func updateConversation(conversationID: Int,
                            title: String?,
                            participants: [User]?,
                            image: Data?) -> AnyPublisher<Conversation, Error> {
        conversationNetworkRepository
            .updateConversation(
                conversationID: conversationID,
                title: title,
                participants: participants,
                image: image
            )
            .handleEvents(receiveOutput: { [weak self] in
                self?.detailConversationLocalRepository.saveConversationDetails([$0])
            })
            .eraseToAnyPublisher()
    }

    func addParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Conversation, Error> {
        conversationParticipantNetworkRepository
            .addParticipant(conversationID: conversationID, participants: participants)
            .flatMap { [weak self] in
                guard let self else { return Empty<Conversation, Error>().eraseToAnyPublisher() }
                return self.conversationNetworkRepository.getConversation(conversationID: conversationID)
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.detailConversationLocalRepository.saveConversationDetails([$0])
            })
            .eraseToAnyPublisher()
    }

    func removeParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Conversation, Error> {
        conversationParticipantNetworkRepository
            .removeParticipant(conversationID: conversationID, participants: participants)
            .flatMap { [weak self] in
                guard let self else { return Empty<Conversation, Error>().eraseToAnyPublisher() }
                return self.conversationNetworkRepository.getConversation(conversationID: conversationID)
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.detailConversationLocalRepository.saveConversationDetails([$0])
            })
            .eraseToAnyPublisher()
    }

    func assignAdmin(conversationID: Int, admin: User) -> AnyPublisher<Conversation, Error> {
        conversationParticipantNetworkRepository
            .assignAdmin(conversationID: conversationID, admin: admin)
            .flatMap { [weak self] in
                guard let self else { return Empty<Conversation, Error>().eraseToAnyPublisher() }
                return self.conversationNetworkRepository.getConversation(conversationID: conversationID)
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.detailConversationLocalRepository.saveConversationDetails([$0])
            })
            .eraseToAnyPublisher()
    }

    func leave(conversationID: Int) -> AnyPublisher<Conversation, Error> {
        guard let currentUser = userLocalRepository.getCurrentUser() else {
            return Fail<Conversation, Error>(error: CommonError.currentUserNotFound)
                .eraseToAnyPublisher()
        }
        return removeParticipant(conversationID: conversationID, participants: [currentUser])
    }
}
