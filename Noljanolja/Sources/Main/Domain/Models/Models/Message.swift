//
//  Message.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation

// MARK: - MessageType

enum MessageType: String, Codable {
    case plaintext = "PLAINTEXT"
    case photo = "PHOTO"
    case sticker = "STICKER"
    case eventUpdated = "EVENT_UPDATED"
    case eventJoined = "EVENT_JOINED"
    case eventLeft = "EVENT_LEFT"
    case unknown = "UNKOWN"

    var isSupported: Bool {
        switch self {
        case .plaintext, .photo, .sticker, .eventUpdated, .eventJoined, .eventLeft:
            return true
        case .unknown:
            return false
        }
    }

    var isSessionEnabled: Bool {
        switch self {
        case .plaintext, .photo, .sticker:
            return true
        case .eventUpdated, .eventJoined, .eventLeft, .unknown:
            return false
        }
    }
}

// MARK: - Message

struct Message: Equatable, Decodable {
    let id: Int?
    let localID: String?
    let conversationID: Int
    let message: String?
    let type: MessageType
    let sender: User
    let leftParticipants: [User]
    let joinParticipants: [User]
    let seenBy: [String]
    let attachments: [Attachment]
    let reactions: [MessageReaction]
    let createdAt: Date
    let isDeleted: Bool
    let shareVideo: Video?
    var shareMessage: Message? {
        shareMessages?.compactMap { $0 }.first
    }

    var replyToMessage: Message? {
        replyToMessages?.compactMap { $0 }.first
    }

    private let shareMessages: [Message?]?
    private let replyToMessages: [Message?]?

    enum CodingKeys: String, CodingKey {
        case id
        case localID = "localId"
        case conversationID = "conversationId"
        case message
        case type
        case sender
        case leftParticipants
        case joinParticipants
        case seenBy
        case attachments
        case reactions
        case createdAt
        case isDeleted
        case shareVideo
        case shareMessage
        case replyToMessage
    }

    init(id: Int?,
         localID: String?,
         conversationID: Int,
         message: String?,
         type: MessageType,
         sender: User,
         leftParticipants: [User],
         joinParticipants: [User],
         seenBy: [String],
         attachments: [Attachment],
         reactions: [MessageReaction],
         createdAt: Date,
         isDeleted: Bool,
         shareVideo: Video?,
         shareMessage: Message?,
         replyToMessage: Message?) {
        self.id = id
        self.localID = localID
        self.conversationID = conversationID
        self.message = message
        self.type = type
        self.sender = sender
        self.leftParticipants = leftParticipants
        self.joinParticipants = joinParticipants
        self.seenBy = seenBy
        self.attachments = attachments
        self.reactions = reactions
        self.createdAt = createdAt
        self.isDeleted = isDeleted
        self.shareVideo = shareVideo
        self.shareMessages = [shareMessage]
        self.replyToMessages = [replyToMessage]
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.localID = try container.decodeIfPresent(String.self, forKey: .localID)
        self.conversationID = try container.decode(Int.self, forKey: .conversationID)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.type = (try? container.decode(MessageType.self, forKey: .type)) ?? .unknown
        self.sender = try container.decode(User.self, forKey: .sender)
        self.leftParticipants = try container.decodeIfPresent([User].self, forKey: .leftParticipants) ?? []
        self.joinParticipants = try container.decodeIfPresent([User].self, forKey: .joinParticipants) ?? []
        self.seenBy = try container.decodeIfPresent([String].self, forKey: .seenBy) ?? []
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments) ?? []
        self.reactions = try container.decodeIfPresent([MessageReaction].self, forKey: .reactions) ?? []

        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt),
           let createdAt = createdAtString.date(withFormats: NetworkConfigs.Format.apiFullDateFormats) {
            self.createdAt = createdAt
        } else {
            throw DecodingError.valueNotFound(
                String.self,
                DecodingError.Context(
                    codingPath: container.codingPath + [CodingKeys.createdAt],
                    debugDescription: ""
                )
            )
        }

        self.isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        self.shareVideo = try container.decodeIfPresent(Video.self, forKey: .shareVideo)
        self.shareMessages = [try container.decodeIfPresent(Message.self, forKey: .shareMessage)]
        self.replyToMessages = [try container.decodeIfPresent(Message.self, forKey: .replyToMessage)]
    }

    func getStickerURL() -> URL? {
        if let message {
            return MediaUseCasesImpl.default.getStickerURL(stickerPath: message)
        } else {
            return nil
        }
    }
}
