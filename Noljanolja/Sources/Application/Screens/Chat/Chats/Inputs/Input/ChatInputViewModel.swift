//
//  ChatInputViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//
//

import Combine
import Foundation

// MARK: - ChatInputViewModelDelegate

protocol ChatInputViewModelDelegate: AnyObject {}

// MARK: - ChatInputViewModelType

protocol ChatInputViewModelType: ObservableObject {
    // MARK: State

    var text: String { get set }
    var photoAssets: [PhotoAsset] { get set }

    // MARK: Action

    var sendTextSubject: PassthroughSubject<Void, Never> { get }
    var sendPhotoSubject: PassthroughSubject<Void, Never> { get }
    var sendStickerSubject: PassthroughSubject<(StickerPack, Sticker), Never> { get }
}

// MARK: - ChatInputViewModel

final class ChatInputViewModel: ChatInputViewModelType {
    // MARK: State

    @Published var text = ""
    @Published var photoAssets = [PhotoAsset]()

    // MARK: Dependencies

    private let conversationID: Int
    private let messageService: MessageServiceType
    private weak var delegate: ChatInputViewModelDelegate?

    // MARK: Action

    let sendTextSubject = PassthroughSubject<Void, Never>()
    let sendPhotoSubject = PassthroughSubject<Void, Never>()
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

        let sendPublisher = Publishers.Merge3(
            sendTextSubject
                .map { [weak self] in
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .plaintext,
                        message: self?.text
                    )
                },
            sendPhotoSubject
                .map { [weak self] in
                    SendMessageRequest(
                        conversationID: conversationID,
                        type: .photo,
                        photos: self?.photoAssets
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
            .sink { [weak self] result in
                switch result {
                case let .success(message):
                    switch message.type {
                    case .plaintext:
                        self?.text = ""
                    case .photo:
                        self?.photoAssets = []
                    case .sticker, .gif, .document:
                        break
                    }
                case .failure:
                    break
                }
                print(result)
            }
            .store(in: &cancellables)
    }
}
