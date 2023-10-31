//
//  ChatStickerPacksInputViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//
//

import Combine
import Foundation

// MARK: - ChatStickerPacksInputViewModelDelegate

protocol ChatStickerPacksInputViewModelDelegate: AnyObject {
    func chatStickerPacksInputViewModel(previewSticker stickerPack: StickerPack, sticker: Sticker)
    func chatStickerPacksInputViewModel(sendSticker stickerPack: StickerPack, sticker: Sticker)
}

// MARK: - ChatStickerPacksInputViewModel

final class ChatStickerPacksInputViewModel: ViewModel {
    // MARK: State

    @Published var stickerPacks = [StickerPack]()
    @Published var viewState = ViewState.loading
    @Published var error: Error?

    // MARK: Action

    // MARK: Dependencies

    private let mediaUseCases: MediaUseCases
    private weak var delegate: ChatStickerPacksInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(mediaUseCases: MediaUseCases = MediaUseCasesImpl.default,
         delegate: ChatStickerPacksInputViewModelDelegate? = nil) {
        self.mediaUseCases = mediaUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapToResult { [weak self] _ -> AnyPublisher<[StickerPack], Error> in
                guard let self else {
                    return Empty<[StickerPack], Error>().eraseToAnyPublisher()
                }
                return self.mediaUseCases.getStickerPacks()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case let .success(stickerPacks):
                    self?.stickerPacks = stickerPacks
                    self?.viewState = .content
                case let .failure(error):
                    self?.error = error
                    self?.viewState = .error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: ChatStickerInputViewModelDelegate

extension ChatStickerPacksInputViewModel: ChatStickerInputViewModelDelegate {
    func chatStickerInputViewModel(previewSticker stickerPack: StickerPack, sticker: Sticker) {
        delegate?.chatStickerPacksInputViewModel(previewSticker: stickerPack, sticker: sticker)
    }

    func chatStickerInputViewModel(sendSticker stickerPack: StickerPack, sticker: Sticker) {
        delegate?.chatStickerPacksInputViewModel(sendSticker: stickerPack, sticker: sticker)
    }
}
