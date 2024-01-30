//
//  UncompleteVideosViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/08/2023.
//
//

import Combine
import Foundation

// MARK: - UncompleteVideosViewModelDelegate

protocol UncompleteVideosViewModelDelegate: AnyObject {}

// MARK: - UncompleteVideosViewModel

final class UncompleteVideosViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var models = [Video]()

    // MARK: Navigations

    @Published var navigationType: UncompleteVideosNavigationType?

    // MARK: Action

    // MARK: Dependencies

    private let videoNetworkRepository: VideoNetworkRepository
    private weak var delegate: UncompleteVideosViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(videoNetworkRepository: VideoNetworkRepository = VideoNetworkRepositoryImpl.shared,
         delegate: UncompleteVideosViewModelDelegate? = nil) {
        self.videoNetworkRepository = videoNetworkRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Fail<[Video], Error>(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.videoNetworkRepository.getWatchingVideos()
            }
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case let .success(models):
                    self.models = models
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
    }
}
