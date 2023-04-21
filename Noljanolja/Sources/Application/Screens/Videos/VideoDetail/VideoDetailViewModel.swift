//
//  VideoDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//
//

import Combine
import Foundation

// MARK: - VideoDetailViewModelDelegate

protocol VideoDetailViewModelDelegate: AnyObject {}

// MARK: - VideoDetailViewModel

final class VideoDetailViewModel: ViewModel {
    // MARK: State

    @Published var video: Video?
    @Published var comments = [VideoComment]()
    @Published var viewState = ViewState.loading

    // MARK: Action

    // MARK: Dependencies

    private let videoId: String
    private let videoAPI: VideoAPIType
    private weak var delegate: VideoDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(videoId: String,
         videoAPI: VideoAPIType = VideoAPI.default,
         delegate: VideoDetailViewModelDelegate? = nil) {
        self.videoId = videoId
        self.videoAPI = videoAPI
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<Video, Error> in
                guard let self else {
                    return Empty<Video, Error>().eraseToAnyPublisher()
                }
                return self.videoAPI.getVideoDetail(id: self.videoId)
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(video):
                    self.video = video
                    self.comments = video.comments
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
    }
}
