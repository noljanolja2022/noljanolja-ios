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
    func sendMessage(request: SendMessageRequest) -> AnyPublisher<Message, Error>
    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error>

    func getPhotoURL(conversationID: Int, attachmentId: String, fileName: String?) -> URL?
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

    private let userService: UserServiceType
    private let messageAPI: MessageAPIType
    private let messageStore: MessageStoreType
    private let photoAssetAPI: PhotoAssetAPI

    private init(userService: UserServiceType = UserService.default,
                 messageAPI: MessageAPIType = MessageAPI.default,
                 conversationStore: ConversationStoreType = ConversationStore.default,
                 messageStore: MessageStoreType = MessageStore.default,
                 photoAssetAPI: PhotoAssetAPI = PhotoAssetAPI.default) {
        self.userService = userService
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

    func sendMessage(request: SendMessageRequest) -> AnyPublisher<Message, Error> {
        var message: String? {
            switch request.type {
            case .plaintext:
                return request.message
            case .sticker:
                if let sticker = request.sticker {
                    return "\(sticker.0.id)/\(sticker.1.imageFile)"
                } else {
                    return nil
                }
            case .photo, .document, .gif:
                return nil
            }
        }

        let attachmentsPublisher = buildAttachmentTrigger(request.attachments)
            .handleEvents(receiveOutput: {
                $0?.forEach { [weak self] in
                    guard let data = $0.data else { return }
                    try? self?.messageStore
                        .savePhoto(
                            conversationID: request.conversationID,
                            fileName: $0.name,
                            data: data
                        )
                }
            })

        return attachmentsPublisher
            .withLatestFrom(userService.currentUserPublisher.setFailureType(to: Error.self)) { ($0, $1) }
            .map { attachments, currentUser in
                SendMessageParam(
                    currentUser: currentUser,
                    localID: UUID().uuidString,
                    conversationID: request.conversationID,
                    type: request.type,
                    message: message,
                    attachments: attachments
                )
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.saveMessageParams([$0])
            })
            .flatMapLatest { [weak self] param -> AnyPublisher<Message, Error> in
                guard let self else {
                    return Empty<Message, Error>().eraseToAnyPublisher()
                }
                return self.messageAPI
                    .sendMessage(param: param)
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

    func getPhotoURL(conversationID: Int, attachmentId: String, fileName: String?) -> URL? {
        let localStickerURL = fileName.flatMap {
            messageStore.getPhotoURL(conversationID: conversationID, fileName: $0)
        }
        let remoteStickerURL = messageAPI.getPhotoURL(conversationId: conversationID, attachmentId: attachmentId)
        return localStickerURL ?? remoteStickerURL
    }
}

extension MessageService {
    private func buildAttachmentTrigger(_ attachment: AttachmentsRequest?) -> AnyPublisher<[AttachmentParam]?, Error> {
        switch attachment {
        case let .images(images):
            if let images {
                let params = images.map { image in
                    let id = UUID().uuidString
                    return AttachmentParam(
                        id: id,
                        name: "\(id).png",
                        data: image.pngData()
                    )
                }
                return Just(params)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        case let .photos(photos):
            if let photos {
                return photoAssetAPI
                    .requestImage(photos)
                    .map { photoModels -> [AttachmentParam]? in
                        photoModels?.map { photoModel -> AttachmentParam in
                            let id = UUID().uuidString
                            return AttachmentParam(
                                id: id,
                                name: "\(id).png",
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
        case .none:
            return Just(nil)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
