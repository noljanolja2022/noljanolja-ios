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

protocol ChatStickerPacksInputViewModelDelegate: AnyObject {}

// MARK: - ChatStickerPacksInputViewModel

final class ChatStickerPacksInputViewModel: ViewModel {
    // MARK: State

    @Published var stickerPacks = [StickerPack]()
    @Published var viewState = ViewState.loading
    @Published var error: Error?

    // MARK: Action

    // MARK: Dependencies

    private let mediaService: MediaServiceType
    private weak var delegate: ChatStickerPacksInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(mediaService: MediaServiceType = MediaService.default,
         delegate: ChatStickerPacksInputViewModelDelegate? = nil) {
        self.mediaService = mediaService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapToResult { [weak self] _ -> AnyPublisher<[StickerPack], Error> in
                guard let self else {
                    return Empty<[StickerPack], Error>().eraseToAnyPublisher()
                }
                return self.mediaService.getStickerPacks()
            }
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
