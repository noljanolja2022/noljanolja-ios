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

protocol VideosViewModelDelegate: AnyObject {
    func videosViewModelSignOut()
}

// MARK: - VideosViewModel

final class VideosViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var model = VideosModel()
    @Published var avatarURL: String?

    // MARK: Navigations

    @Published var navigationType: VideosNavigationType?
    @Published var fullScreenCoverType: VideosFullScreenCoverType?

    // MARK: Action

    let loadMoreTrendingVideos = PassthroughSubject<Int, Never>()
    @Published var isShowToastCopy = false
    @Published var isProgressHUDShowing = false

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private let videoNetworkRepository: VideoNetworkRepository
    private weak var delegate: VideosViewModelDelegate?

    // MARK: Private

    let highlightVideosSubject = CurrentValueSubject<[Video], Never>([])
    let watchingVideosSubject = CurrentValueSubject<[Video], Never>([])
    let trendingVideosSubject = CurrentValueSubject<[Video], Never>([])
    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)

    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(videoNetworkRepository: VideoNetworkRepository = VideoNetworkRepositoryImpl.shared,
         userUseCases: UserUseCases = UserUseCasesImpl.default,
         delegate: VideosViewModelDelegate? = nil) {
        self.videoNetworkRepository = videoNetworkRepository
        self.userUseCases = userUseCases
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

        currentUserSubject.sink { [weak self] user in
            self?.avatarURL = user?.avatar
        }
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
                return self.videoNetworkRepository.getWatchingVideos()
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

        userUseCases.getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)
    }

    private func getDatas() -> AnyPublisher<VideosModel, Error> {
        let highlightVideos = videoNetworkRepository
            .getVideos(page: 1, pageSize: pageSize, isHighlighted: true)
            .mapToResult()
        let watchingVideos = videoNetworkRepository
            .getWatchingVideos()
            .mapToResult()
        let trendingVideos = videoNetworkRepository
            .getTrendingVideos(duration: .day, limit: pageSize)
            .mapToResult()

        return Publishers.Zip3(
            highlightVideos,
            watchingVideos,
            trendingVideos
        )
        .tryMap { highlightResult, watchingResult, trendingResult in
            let highlightVideos = highlightResult.success?.data ?? []
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

// MARK: VideoActionContainerViewModelDelegate

extension VideosViewModel: VideoActionContainerViewModelDelegate {
    func pushToChat(conversationId: Int?) {
        guard let conversationId else { return }
        navigationType = .chat(conversationId: conversationId)
    }

    func showToastCopy() {
        isShowToastCopy = true
    }

    func ignoreVideo(videoId: String) {
        videoNetworkRepository.ignoreVideo(videoId: videoId)
            .mapToResult()
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.trendingVideosSubject.send(self.model.trendingVideos.filter { $0.id != videoId })
                self.isProgressHUDShowing = false
            }
            .store(in: &cancellables)
    }
}

// MARK: ProfileSettingViewModelDelegate

extension VideosViewModel: ProfileSettingViewModelDelegate {
    func profileSettingViewModelSignOut() {
        delegate?.videosViewModelSignOut()
    }
}
