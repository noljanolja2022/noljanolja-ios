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

// MARK: - ChatInputViewModelType

protocol ChatInputViewModelType: ObservableObject {
    // MARK: State

    // MARK: Action

    var sendTextSubject: PassthroughSubject<String, Never> { get }
    var sendImagesSubject: PassthroughSubject<[UIImage], Never> { get }
    var sendPhotosSubject: PassthroughSubject<[PhotoAsset], Never> { get }
    var sendStickerSubject: PassthroughSubject<(StickerPack, Sticker), Never> { get }
}

// MARK: - ChatInputViewModel

final class ChatInputViewModel: ChatInputViewModelType {
    // MARK: State

    // MARK: Dependencies

    private let conversationID: Int
    private let messageService: MessageServiceType
    private weak var delegate: ChatInputViewModelDelegate?

    // MARK: Action

    let sendTextSubject = PassthroughSubject<String, Never>()
    let sendImagesSubject = PassthroughSubject<[UIImage], Never>()
    let sendPhotosSubject = PassthroughSubject<[PhotoAsset], Never>()
    let sendStickerSubject = PassthroughSubject<(StickerPack, Sticker), Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversationID: Int,
         messageService: MessageServiceType = MessageService.default,
         delegate: ChatInputViewModelDelegate? = nil) {
        self.conversationID = conversationID
        self.messageService = messageService
        self.delegate = delegate

        configure()
    }

    private func configure() {
        let conversationID = conversationID

        let sendPublisher = Publishers.Merge4(
            sendTextSubject
                .filter { !$0.isEmpty }
                .map {
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .plaintext,
                        message: $0
                    )
                },
            sendImagesSubject
                .map {
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        attachments: .images($0)
                    )
                },
            sendPhotosSubject
                .map {
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        attachments: .photos($0)
                    )
                },
            sendStickerSubject
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
