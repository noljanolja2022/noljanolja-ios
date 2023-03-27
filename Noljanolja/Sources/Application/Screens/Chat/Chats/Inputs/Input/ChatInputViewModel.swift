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
        let sendPublisher = Publishers.Merge3(
            sendTextSubject
                .map { [weak self] in
                    SendMessageParam(
                        type: .plaintext,
                        message: self?.text
                    )
                },
            sendPhotoSubject
                .map { [weak self] in
                    SendMessageParam(
                        type: .photo,
                        photos: self?.photoAssets
                    )
                },
            sendStickerSubject
                .map {
                    SendMessageParam(
                        type: .sticker,
                        sticker: $0
                    )
                }
        )
        
        sendPublisher
            .flatMapToResult { [weak self] param in
                guard let self else {
                    return Empty<Message, Error>().eraseToAnyPublisher()
                }
                return self.messageService
                    .sendMessage(conversationID: self.conversationID, param: param)
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
