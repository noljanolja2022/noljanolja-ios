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

protocol ChatStickerInputViewModelDelegate: AnyObject {}

// MARK: - ChatStickerInputViewModelType

protocol ChatStickerInputViewModelType: ObservableObject {
    // MARK: State

    var stickerPack: StickerPack { get set }
    var viewState: ViewState { get set }

    // MARK: Action

    var loadDataSubject: PassthroughSubject<Void, Never> { get }
    var downloadDataSubject: PassthroughSubject<Void, Never> { get }
}

// MARK: - ChatStickerInputViewModel

final class ChatStickerInputViewModel: ChatStickerInputViewModelType {
    // MARK: State

    @Published var stickerPack: StickerPack
    @Published var viewState = ViewState.loading

    // MARK: Action

    let loadDataSubject = PassthroughSubject<Void, Never>()
    let downloadDataSubject = PassthroughSubject<Void, Never>()

    private let reloadDataSubject = PassthroughSubject<Void, Never>()

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

        configure()
    }

    private func configure() {
        Publishers.Merge(
            loadDataSubject.first(),
            reloadDataSubject
        )
        .sink(receiveValue: { [weak self] in self?.checkLocalStickerPack() })
        .store(in: &cancellables)

        downloadDataSubject
            .handleEvents(receiveOutput: { [weak self] in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                return self.mediaService.downloadStickerPack(id: self.stickerPack.id)
            }
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.reloadDataSubject.send()
                case let .failure(error):
                    self?.viewState = .error
                }
            })
            .store(in: &cancellables)
    }

    private func checkLocalStickerPack() {
        if mediaService.getLocalStickerPackURL(id: stickerPack.id) != nil {
            viewState = .content
        } else {
            viewState = .error
        }
    }
}
