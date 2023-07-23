//
//  ChatStickerInputViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//
//

import Combine
import Foundation

// MARK: - ChatStickerInputViewModelDelegate

protocol ChatStickerInputViewModelDelegate: AnyObject {
    func chatStickerInputViewModel(previewSticker stickerPack: StickerPack, sticker: Sticker)
    func chatStickerInputViewModel(sendSticker stickerPack: StickerPack, sticker: Sticker)
}

// MARK: - ChatStickerInputViewModel

final class ChatStickerInputViewModel: ViewModel {
    // MARK: State

    @Published var stickerPack: StickerPack
    @Published var viewState = ViewState.loading

    // MARK: Action

    let downloadDataAction = PassthroughSubject<Void, Never>()
    let reloadDataAction = PassthroughSubject<Void, Never>()
    let previewStickerAction = PassthroughSubject<(StickerPack, Sticker), Never>()
    let sendStickerAction = PassthroughSubject<(StickerPack, Sticker), Never>()

    // MARK: Dependencies

    private let mediaService: MediaServiceType
    private weak var delegate: ChatStickerInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(stickerPack: StickerPack,
         mediaService: MediaServiceType = MediaService.default,
         delegate: ChatStickerInputViewModelDelegate? = nil) {
        self.stickerPack = stickerPack
        self.mediaService = mediaService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        Publishers.Merge(
            isAppearSubject.first(where: { $0 }).mapToVoid(),
            reloadDataAction
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] in
            guard let self else { return }
            if self.mediaService.getLocalStickerPackURL(id: self.stickerPack.id) != nil {
                self.viewState = .content
            } else {
                self.viewState = .error
            }
        })
        .store(in: &cancellables)

        downloadDataAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.mediaService.downloadStickerPack(id: self.stickerPack.id)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.reloadDataAction.send()
                case .failure:
                    self?.viewState = .error
                }
            })
            .store(in: &cancellables)
    }

    private func configureActions() {
        previewStickerAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stickerPack, sticker in
                self?.delegate?.chatStickerInputViewModel(previewSticker: stickerPack, sticker: sticker)
            }
            .store(in: &cancellables)

        sendStickerAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stickerPack, sticker in
                self?.delegate?.chatStickerInputViewModel(sendSticker: stickerPack, sticker: sticker)
            }
            .store(in: &cancellables)
    }
}
