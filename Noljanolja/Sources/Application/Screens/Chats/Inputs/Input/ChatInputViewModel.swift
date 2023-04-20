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

    let sendTextAction = PassthroughSubject<String, Never>()
    let sendImagesAction = PassthroughSubject<[UIImage], Never>()
    let sendPhotosAction = PassthroughSubject<[PhotoAsset], Never>()
    let sendStickerAction = PassthroughSubject<(StickerPack, Sticker), Never>()

    // MARK: Dependencies

    private let conversationID: Int
    private let messageService: MessageServiceType
    private weak var delegate: ChatInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversationID: Int,
         messageService: MessageServiceType = MessageService.default,
         delegate: ChatInputViewModelDelegate? = nil) {
        self.conversationID = conversationID
        self.messageService = messageService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        let conversationID = conversationID

        let sendPublisher = Publishers.Merge4(
            sendTextAction
                .filter { !$0.isEmpty }
                .map {
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .plaintext,
                        message: $0
                    )
                },
            sendImagesAction
                .map {
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        attachments: .images($0)
                    )
                },
            sendPhotosAction
                .map {
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        attachments: .photos($0)
                    )
                },
            sendStickerAction
                .map {
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .sticker,
                        sticker: $0
                    )
                }
        )
        
        sendPublisher
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
        sendImagesAction.send(images)
    }
}
