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

    func shareMessage(request: ShareMessageRequest, users: [User]) -> AnyPublisher<[Message], Error>

    func forwardMessage(message: Message, users: [User]) -> AnyPublisher<[Message], Error>

    func deleteMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error>

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

    private let userStore: UserStoreType
    private let messageAPI: MessageAPIType
    private let conversationService: ConversationServiceType
    private let messageStore: MessageStoreType
    private let photoAssetAPI: PhotoAssetAPI
    private let dataRepository: DataRepository

    private init(userStore: UserStoreType = UserStore.default,
                 messageAPI: MessageAPIType = MessageAPI.default,
                 conversationService: ConversationServiceType = ConversationService.default,
                 messageStore: MessageStoreType = MessageStore.default,
                 photoAssetAPI: PhotoAssetAPI = PhotoAssetAPI.default,
                 dataRepository: DataRepository = DataRepositoryImpl.shared) {
        self.userStore = userStore
        self.messageAPI = messageAPI
        self.conversationService = conversationService
        self.messageStore = messageStore
        self.photoAssetAPI = photoAssetAPI
        self.dataRepository = dataRepository
    }

    func getLocalMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        messageStore
            .observeMessages(conversationID: conversationID)
            .map {
                $0
                    .filter { !$0.isDeleted }
                    .sorted { $0.createdAt > $1.createdAt }
            }
            .removeDuplicates()
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
            .receive(on: DispatchQueue.main) // NOTED: Do on serial queue to wait write then read
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
            case .photo, .eventUpdated, .eventJoined, .eventLeft, .unknown:
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
            .withLatestFrom(
                userStore
                    .getCurrentUserPublisher()
                    .setFailureType(to: Error.self)
            ) { ($0, $1) }
            .map { attachments, currentUser in
                SendMessageParam(
                    currentUser: currentUser,
                    localID: UUID().uuidString,
                    conversationID: request.conversationID,
                    type: request.type,
                    message: message,
                    attachments: attachments,
                    shareMessage: request.shareMessage,
                    replyToMessage: request.replyToMessage
                )
            }
            .receive(on: DispatchQueue.main) // NOTED: Do on serial queue to wait write then read
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.saveMessageParameters([$0])
            })
            .flatMapLatest { [weak self] param -> AnyPublisher<Message, Error> in
                guard let self else {
                    return Empty<Message, Error>().eraseToAnyPublisher()
                }
                return self.messageAPI
                    .sendMessage(param: param)
            }
            .receive(on: DispatchQueue.main) // NOTED: Do on serial queue to wait write then read
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.saveMessages([$0])
            })
            .eraseToAnyPublisher()
    }

    func shareMessage(request: ShareMessageRequest, users: [User]) -> AnyPublisher<[Message], Error> {
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
            case .photo, .eventUpdated, .eventJoined, .eventLeft, .unknown:
                return nil
            }
        }

        let attachmentsPublisher = buildAttachmentTrigger(request.attachments)

        let conversationPublishers = users
            .map { user in
                self.conversationService.createConversation(
                    type: .single,
                    participants: [user]
                )
            }
        let conversationsPublisher = Publishers.MergeMany(conversationPublishers).collect()

        return Publishers.Zip(attachmentsPublisher, conversationsPublisher)
            .map { attachments, conversations in
                ShareMessageParam(
                    type: request.type,
                    message: message,
                    attachments: attachments,
                    shareMessageID: request.shareMessage?.id,
                    replyToMessageID: request.replyToMessage?.id,
                    shareVideoID: request.shareVideo?.id,
                    conversationIDs: conversations.map { $0.id }
                )
            }
            .flatMapLatest { [weak self] param -> AnyPublisher<[Message], Error> in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.messageAPI
                    .shareMessage(param: param)
            }
            .receive(on: DispatchQueue.main) // NOTED: Do on serial queue to wait write then read
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.saveMessages($0)
            })
            .eraseToAnyPublisher()
    }

    func forwardMessage(message: Message, users: [User]) -> AnyPublisher<[Message], Error> {
        let attachmentPublishers = message.attachments
            .compactMap {
                $0.getPhotoURL(conversationID: message.conversationID)
            }
            .compactMap {
                self.dataRepository.getData(url: $0)
                    .map {
                        let id = UUID().uuidString
                        return AttachmentParam(
                            id: id,
                            name: "\(id).png",
                            data: $0
                        )
                    }
            }

        let attachmentPublisher = Publishers.MergeMany(attachmentPublishers)
            .collect()
            .eraseToAnyPublisher()

        return attachmentPublisher
            .flatMapLatest { [weak self] attachments in
                guard let self else {
                    return Empty<[Message], Error>().eraseToAnyPublisher()
                }
                return self.userStore
                    .getCurrentUserPublisher()
                    .setFailureType(to: Error.self)
                    .flatMapLatest { [weak self] currentUser in
                        guard let self else {
                            return Empty<[Message], Error>().eraseToAnyPublisher()
                        }
                        let messages = users
                            .map { user in
                                self.conversationService.createConversation(
                                    type: .single,
                                    participants: [user]
                                )
                                .flatMapLatest { conversation in
                                    self.messageAPI.sendMessage(
                                        param: SendMessageParam(
                                            currentUser: currentUser,
                                            localID: UUID().uuidString,
                                            conversationID: conversation.id,
                                            type: message.type,
                                            message: message.message,
                                            attachments: attachments,
                                            shareMessage: message,
                                            replyToMessage: nil
                                        )
                                    )
                                }
                            }
                        let message: AnyPublisher<[Message], Error> = Publishers.MergeMany(messages)
                            .collect()
                            .eraseToAnyPublisher()

                        return message
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func deleteMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error> {
        messageAPI
            .deleteMessage(conversationID: conversationID, messageID: messageID)
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageStore.deleteMessage(conversationID: conversationID, messageID: messageID)
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
                let parameters = images.map { image in
                    let id = UUID().uuidString
                    return AttachmentParam(
                        id: id,
                        name: "\(id).png",
                        data: image.jpegData(compressionQuality: 0.5)
                    )
                }
                return Just(parameters)
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
