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

protocol ChatInputViewModelDelegate: AnyObject {
    func chatInputViewModel(type: SendMessageType)
}

// MARK: - ChatInputViewModel

final class ChatInputViewModel: ViewModel {
    // MARK: State

    @Published var previewSticker: (StickerPack, Sticker)?

    // MARK: Action

    let sendAction = PassthroughSubject<SendMessageType, Never>()
    let didReceiveTextViewAction = PassthroughSubject<Void, Never>()
    let isTextFirstResponderAction = PassthroughSubject<Bool, Never>()

    // MARK: Dependencies

    private let conversationID: Int
    private let messageUseCases: MessageUseCases
    private weak var delegate: ChatInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(conversationID: Int,
         messageUseCases: MessageUseCases = MessageUseCasesImpl.default,
         delegate: ChatInputViewModelDelegate? = nil) {
        self.conversationID = conversationID
        self.messageUseCases = messageUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        Publishers.CombineLatest(
            isAppearSubject.filter { $0 }.mapToVoid(),
            didReceiveTextViewAction
        )
        .first()
        .delay(for: 0.5, scheduler: DispatchQueue.main)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.isTextFirstResponderAction.send(true)
        }
        .store(in: &cancellables)

        sendAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.chatInputViewModel(type: $0)
            }
            .store(in: &cancellables)
    }
}

// MARK: ChatInputExpandViewModelDelegate

extension ChatInputViewModel: ChatInputExpandViewModelDelegate {
    func chatInputExpandViewModel(sendImages images: [UIImage]) {
        delegate?.chatInputViewModel(type: .images(images))
    }

    func chatInputExpandViewModel(previewSticker stickerPack: StickerPack, sticker: Sticker) {
        previewSticker = (stickerPack, sticker)
    }

    func chatInputExpandViewModel(sendSticker stickerPack: StickerPack, sticker: Sticker) {
        delegate?.chatInputViewModel(type: .sticker(stickerPack, sticker))
    }
}
