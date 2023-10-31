//
//  ConversationParticipantRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import Combine
import Foundation
import Moya

// MARK: - ConversationParticipantTargets

private enum ConversationParticipantTargets {
    struct AddParticipant: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/participants" }
        let method: Moya.Method = .put
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        var conversationID: Int
        let participants: [User]

        var parameters: [String: Any] {
            [
                "participantIds": participants.map { $0.id }
            ]
        }
    }

    struct RemoveParticipant: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/participants" }
        let method: Moya.Method = .delete
        var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

        var conversationID: Int
        let participants: [User]

        var parameters: [String: Any] {
            [
                "participantIds": participants.map { String($0.id) }.joined(separator: ",")
            ]
        }
    }

    struct AssignAdmin: BaseAuthTargetType {
        var path: String { "v1/conversations/\(conversationID)/admin" }
        let method: Moya.Method = .put
        var task: Task { .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }

        var conversationID: Int
        let admin: User

        var parameters: [String: Any] {
            [
                "assigneeId": admin.id
            ]
        }
    }
}

// MARK: - ConversationParticipantRepository

protocol ConversationParticipantRepository {
    func addParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Void, Error>
    func removeParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Void, Error>
    func assignAdmin(conversationID: Int, admin: User) -> AnyPublisher<Void, Error>
}

// MARK: - ConversationParticipantRepositoryImpl

final class ConversationParticipantRepositoryImpl: ConversationParticipantRepository {
    static let `default` = ConversationParticipantRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func addParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Void, Error> {
        api.request(
            target: ConversationParticipantTargets.AddParticipant(
                conversationID: conversationID,
                participants: participants
            )
        )
    }

    func removeParticipant(conversationID: Int, participants: [User]) -> AnyPublisher<Void, Error> {
        api.request(
            target: ConversationParticipantTargets.RemoveParticipant(
                conversationID: conversationID,
                participants: participants
            )
        )
    }

    func assignAdmin(conversationID: Int, admin: User) -> AnyPublisher<Void, Error> {
        api.request(
            target: ConversationParticipantTargets.AssignAdmin(
                conversationID: conversationID,
                admin: admin
            )
        )
    }
}
