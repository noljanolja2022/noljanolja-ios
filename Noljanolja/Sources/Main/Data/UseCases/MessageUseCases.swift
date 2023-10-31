//
//  MessageUseCasesImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import Combine
import Foundation

// MARK: - MessageUseCases

protocol MessageUseCases {
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

extension MessageUseCases {
    func getMessages(conversationID: Int,
                     beforeMessageID: Int? = nil,
                     afterMessageID: Int? = nil) -> AnyPublisher<[Message], Error> {
        getMessages(conversationID: conversationID, beforeMessageID: beforeMessageID, afterMessageID: afterMessageID)
    }
}

// MARK: - MessageUseCasesImpl

final class MessageUseCasesImpl: MessageUseCases {
    static let `default` = MessageUseCasesImpl()

    private let userLocalRepository: UserLocalRepository
    private let messageNetworkRepository: MessageNetworkRepository
    private let conversationUseCases: ConversationUseCases
    private let messageLocalRepository: MessageLocalRepository
    private let photoAssetRepository: PhotoAssetRepository
    private let dataNetworkRepository: DataNetworkRepository

    private init(userLocalRepository: UserLocalRepository = UserLocalRepositoryImpl.default,
                 messageNetworkRepository: MessageNetworkRepository = MessageNetworkRepositoryImpl.default,
                 conversationUseCases: ConversationUseCases = ConversationUseCasesImpl.default,
                 messageLocalRepository: MessageLocalRepository = MessageLocalRepositoryImpl.default,
                 photoAssetRepository: PhotoAssetRepository = PhotoAssetRepository.default,
                 dataNetworkRepository: DataNetworkRepository = DataNetworkRepositoryImpl.shared) {
        self.userLocalRepository = userLocalRepository
        self.messageNetworkRepository = messageNetworkRepository
        self.conversationUseCases = conversationUseCases
        self.messageLocalRepository = messageLocalRepository
        self.photoAssetRepository = photoAssetRepository
        self.dataNetworkRepository = dataNetworkRepository
    }

    func getLocalMessages(conversationID: Int) -> AnyPublisher<[Message], Error> {
        messageLocalRepository
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
        messageNetworkRepository
            .getMessages(
                conversationID: conversationID,
                beforeMessageID: beforeMessageID,
                afterMessageID: afterMessageID
            )
            .receive(on: DispatchQueue.main) // NOTED: Do on serial queue to wait write then read
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageLocalRepository.saveMessages($0)
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
                    try? self?.messageLocalRepository
                        .savePhoto(
                            conversationID: request.conversationID,
                            fileName: $0.name,
                            data: data
                        )
                }
            })

        return attachmentsPublisher
            .withLatestFrom(
                userLocalRepository
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
                self?.messageLocalRepository.saveMessageParameters([$0])
            })
            .flatMapLatest { [weak self] param -> AnyPublisher<Message, Error> in
                guard let self else {
                    return Empty<Message, Error>().eraseToAnyPublisher()
                }
                return self.messageNetworkRepository
                    .sendMessage(param: param)
            }
            .receive(on: DispatchQueue.main) // NOTED: Do on serial queue to wait write then read
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageLocalRepository.saveMessages([$0])
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
                self.conversationUseCases.createConversation(
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
                return self.messageNetworkRepository
                    .shareMessage(param: param)
            }
            .receive(on: DispatchQueue.main) // NOTED: Do on serial queue to wait write then read
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageLocalRepository.saveMessages($0)
            })
            .eraseToAnyPublisher()
    }

    func forwardMessage(message: Message, users: [User]) -> AnyPublisher<[Message], Error> {
        let attachmentPublishers = message.attachments
            .compactMap {
                $0.getPhotoURL(conversationID: message.conversationID)
            }
            .compactMap {
                self.dataNetworkRepository.getData(url: $0)
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
                return self.userLocalRepository
                    .getCurrentUserPublisher()
                    .setFailureType(to: Error.self)
                    .flatMapLatest { [weak self] currentUser in
                        guard let self else {
                            return Empty<[Message], Error>().eraseToAnyPublisher()
                        }
                        let messages = users
                            .map { user in
                                self.conversationUseCases.createConversation(
                                    type: .single,
                                    participants: [user]
                                )
                                .flatMapLatest { conversation in
                                    self.messageNetworkRepository.sendMessage(
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
        messageNetworkRepository
            .deleteMessage(conversationID: conversationID, messageID: messageID)
            .handleEvents(receiveOutput: { [weak self] in
                self?.messageLocalRepository.deleteMessage(conversationID: conversationID, messageID: messageID)
            })
            .eraseToAnyPublisher()
    }

    func seenMessage(conversationID: Int, messageID: Int) -> AnyPublisher<Void, Error> {
        messageNetworkRepository
            .seenMessage(conversationID: conversationID, messageID: messageID)
    }

    func getPhotoURL(conversationID: Int, attachmentId: String, fileName: String?) -> URL? {
        let localStickerURL = fileName.flatMap {
            messageLocalRepository.getPhotoURL(conversationID: conversationID, fileName: $0)
        }
        let remoteStickerURL = messageNetworkRepository.getPhotoURL(conversationId: conversationID, attachmentId: attachmentId)
        return localStickerURL ?? remoteStickerURL
    }
}

extension MessageUseCasesImpl {
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
                return photoAssetRepository
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
