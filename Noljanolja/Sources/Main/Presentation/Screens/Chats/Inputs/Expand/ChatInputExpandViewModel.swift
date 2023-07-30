//
//  ChatInputExpandViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - ChatInputExpandViewModelDelegate

protocol ChatInputExpandViewModelDelegate: AnyObject {
    func chatInputExpandViewModel(sendImages images: [UIImage])
    func chatInputExpandViewModel(previewSticker stickerPack: StickerPack, sticker: Sticker)
    func chatInputExpandViewModel(sendSticker stickerPack: StickerPack, sticker: Sticker)
}

// MARK: - ChatInputExpandViewModel

final class ChatInputExpandViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: ChatInputExpandViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatInputExpandViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: ChatInputExpandMenuViewModelDelegate

extension ChatInputExpandViewModel: ChatInputExpandMenuViewModelDelegate {
    func chatInputExpandMenuViewModel(sendImages images: [UIImage]) {
        delegate?.chatInputExpandViewModel(sendImages: images)
    }
}

// MARK: ChatStickerPacksInputViewModelDelegate

extension ChatInputExpandViewModel: ChatStickerPacksInputViewModelDelegate {
    func chatStickerPacksInputViewModel(previewSticker stickerPack: StickerPack, sticker: Sticker) {
        delegate?.chatInputExpandViewModel(previewSticker: stickerPack, sticker: sticker)
    }

    func chatStickerPacksInputViewModel(sendSticker stickerPack: StickerPack, sticker: Sticker) {
        delegate?.chatInputExpandViewModel(sendSticker: stickerPack, sticker: sticker)
    }
}
