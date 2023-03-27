//
//  MessageService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation

// MARK: - MessageServiceType

protocol MessageServiceType {
    func getLocalMessages(conversationID: Int) -> AnyPublisher<[Message], Error>
    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error>
    func sendMessage(conversationID: Int, param: SendMessageParam) -> AnyPublisher<Message, Error>
    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error>
}

extension MessageServiceType {
    func getMessages(conversationID: Int,
                     beforeMessageID: Int? = nil,
                     afterMessageID: Int? = nil) -> AnyPublisher<[Message], Error> {
        getMessages(conversationID: conversationID, beforeMessageID: beforeMessageID, afterMessageID: afterMessageID)
    }
}

// MARK: - MessageService

final class MessageService: MessageServiceType {
    static let `default` = MessageService()

    private let messageAPI: MessageAPIType
    private let messageStore: MessageStoreType
    private let photoAssetAPI: PhotoAssetAPI

    private init(messageAPI: MessageAPIType = MessageAPI.default,
                 conversationStore: ConversationStoreType = ConversationStore.default,
                 messageStore: MessageStoreType = MessageStore.default,
                 photoAssetAPI: PhotoAssetAPI = PhotoAssetAPI.default) {
        self.messageAPI = messageAPI
        self.messageStore = messageStore
        self.photoAssetAPI = photoAssetAPI
    }

    func getLocalMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        messageStore
            .observeMessages(conversationID: conversationID)
            .map { $0.sorted { $0.createdAt > $1.createdAt } }
            .eraseToAnyPublisher()
    }

    func getMessages(conversationID: Int,
                     beforeMessageID: Int?,
                     afterMessageID: Int?) -> AnyPublisher<[Message], Error> {
        messageAPI
            .getMessages(
                conversationID: conversationID,
                beforeMessageID: beforeMessageID,
                afterMessageID: afterMessageID
            )
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.saveMessages($0)
            })
            .eraseToAnyPublisher()
    }

    func sendMessage(conversationID: Int, param: SendMessageParam) -> AnyPublisher<Message, Error> {
        var message: String? {
            switch param.type {
            case .plaintext:
                return param.message
            case .sticker:
                if let sticker = param.sticker {
                    return "\(sticker.0.id)/\(sticker.1.imageFile)"
                } else {
                    return nil
                }
            case .photo, .document, .gif:
                return nil
            }
        }

        let attachmentsPublisher: AnyPublisher<[AttachmentParam]?, Error> = {
            if let photos = param.photos {
                return photoAssetAPI
                    .requestImage(photos)
                    .map { photoModels -> [AttachmentParam]? in
                        photoModels?.map { photoModel -> AttachmentParam in
                            AttachmentParam(
                                id: photoModel.id,
                                name: photoModel.id,
                                data: photoModel.image.jpegData(compressionQuality: 0.5)
                            )
                        }
                    }
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }()

        return attachmentsPublisher
            .flatMapLatest { [weak self] attachments -> AnyPublisher<Message, Error> in
                guard let self else {
                    return Empty<Message, Error>().eraseToAnyPublisher()
                }
                return self.messageAPI
                    .sendMessage(
                        conversationID: conversationID,
                        type: param.type,
                        message: message,
                        attachments: attachments
                    )
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.saveMessages([$0])
            })
            .eraseToAnyPublisher()
    }

    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error> {
        messageAPI
            .seenMessage(conversationID: conversationID, messageID: messageID)
    }
}
