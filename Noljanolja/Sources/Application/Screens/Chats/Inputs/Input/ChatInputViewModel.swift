//
//  ChatInputViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - ChatInputViewModelDelegate

protocol ChatInputViewModelDelegate: AnyObject {}

// MARK: - ChatInputViewModel

final class ChatInputViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    var sendAction: PassthroughSubject<SendMessageType, Never> {
        privateSendAction
    }

    // MARK: Dependencies

    private let conversationID: Int
    private let privateSendAction: PassthroughSubject<SendMessageType, Never>
    private let messageService: MessageServiceType
    private weak var delegate: ChatInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversationID: Int,
         sendAction: PassthroughSubject<SendMessageType, Never>,
         messageService: MessageServiceType = MessageService.default,
         delegate: ChatInputViewModelDelegate? = nil) {
        self.conversationID = conversationID
        self.privateSendAction = sendAction
        self.messageService = messageService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        let conversationID = conversationID

        sendAction
            .map { sendMessageType in
                switch sendMessageType {
                case let .text(message):
                    return SendMessageRequest(
                        conversationID: conversationID,
                        type: .plaintext,
                        message: message
                    )
                case let .images(images):
                    return SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        attachments: .images(images)
                    )
                case let .photoAssets(photos):
                    return SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        attachments: .photos(photos)
                    )
                case let .sticker(stickerPack, sticker):
                    return SendMessageRequest(
                        conversationID: conversationID,
                        type: .sticker,
                        sticker: (stickerPack, sticker)
                    )
                }
            }
            .flatMapToResult { [weak self] request in
                guard let self else {
                    return Empty<Message, Error>().eraseToAnyPublisher()
                }
                return self.messageService
                    .sendMessage(request: request)
            }
            .sink { result in
                print(result)
            }
            .store(in: &cancellables)
    }
}

// MARK: ChatInputExpandViewModelDelegate

extension ChatInputViewModel: ChatInputExpandViewModelDelegate {
    func didSelectImages(_ images: [UIImage]) {
        sendAction.send(.images(images))
    }
}
