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

    private let videoRepository: VideoRepository
    private weak var delegate: VideosViewModelDelegate?

    // MARK: Private

    let highlightVideosSubject = CurrentValueSubject<[Video], Never>([])
    let watchingVideosSubject = CurrentValueSubject<[Video], Never>([])
    let trendingVideosSubject = CurrentValueSubject<[Video], Never>([])

    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(videoRepository: VideoRepository = VideoRepositoryImpl.shared,
         delegate: VideosViewModelDelegate? = nil) {
        self.videoRepository = videoRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
    }

    private func configureBindData() {
        Publishers.CombineLatest3(
            highlightVideosSubject.removeDuplicates(),
            watchingVideosSubject.removeDuplicates(),
            trendingVideosSubject.removeDuplicates()
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { highlightVideos, watchingVideos, trendingVideos in
            self.model = VideosModel(
                highlightVideos: highlightVideos,
                watchingVideos: watchingVideos,
                trendingVideos: trendingVideos
            )
        })
        .store(in: &cancellables)
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<VideosModel, Error> in
                guard let self else {
                    return Empty<VideosModel, Error>().eraseToAnyPublisher()
                }
                return self.getDatas()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.highlightVideosSubject.send(model.highlightVideos)
                    self.watchingVideosSubject.send(model.watchingVideos)
                    self.trendingVideosSubject.send(model.trendingVideos)
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)

        isAppearSubject
            .filter { $0 }
            .dropFirst()
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[Video], Error> in
                guard let self else {
                    return Empty<[Video], Error>().eraseToAnyPublisher()
                }
                return self.videoRepository.getWatchingVideos()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.watchingVideosSubject.send(model)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func getDatas() -> AnyPublisher<VideosModel, Error> {
        let highlightVideos = videoRepository
            .getVideos(page: 1, pageSize: pageSize, isHighlighted: true)
            .mapToResult()
        let watchingVideos = videoRepository
            .getWatchingVideos()
            .mapToResult()
        let trendingVideos = videoRepository
            .getTrendingVideos(duration: .day, limit: pageSize)
            .mapToResult()

        return Publishers.Zip3(
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
