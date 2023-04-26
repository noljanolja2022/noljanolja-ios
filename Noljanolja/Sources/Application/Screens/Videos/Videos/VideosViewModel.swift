//
//  VideosViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//
//

import Combine
import Foundation

// MARK: - VideosViewModelDelegate

protocol VideosViewModelDelegate: AnyObject {}

// MARK: - VideosViewModel

final class VideosViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var model = VideosModel()

    // MARK: Navigations

    @Published var navigationType: VideosNavigationType?

    // MARK: Action

    let loadMoreTrendingVideos = PassthroughSubject<Int, Never>()

    // MARK: Dependencies

    private let videoAPI: VideoAPIType
    private weak var delegate: VideosViewModelDelegate?

    // MARK: Private

    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(videoAPI: VideoAPIType = VideoAPI.default,
         delegate: VideosViewModelDelegate? = nil) {
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
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<VideosModel, Error> in
                guard let self else {
                    return Empty<VideosModel, Error>().eraseToAnyPublisher()
                }
                return self.getDatas()
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.model = model
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
    }

    private func getDatas() -> AnyPublisher<VideosModel, Error> {
        let highlightVideos = videoAPI
            .getVideos(page: 1, pageSize: pageSize, isHighlighted: true)
            .mapToResult()
        let watchingVideos = CurrentValueSubject<[Video], Error>([])
            .mapToResult()
        let trendingVideos = videoAPI
            .getTrendingVideos(duration: .day, limit: pageSize)
            .mapToResult()

        return Publishers.CombineLatest3(
            highlightVideos,
            watchingVideos,
            trendingVideos
        )
        .tryMap { highlightResult, watchingResult, trendingResult in
            let highlightVideos = highlightResult.success ?? []
            let watchingVideos = watchingResult.success ?? []
            let trendingVideos = trendingResult.success ?? []

            let error = highlightResult.failure ?? (watchingResult.failure ?? trendingResult.failure)

            let model = VideosModel(
                highlightVideos: highlightVideos,
                watchingVideos: watchingVideos,
                trendingVideos: trendingVideos
            )

            if let error, model.isEmpty {
                throw error
            } else {
                return model
            }
        }
        .eraseToAnyPublisher()
    }
}