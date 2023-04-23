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
    @Published var commentCount: Int?
    @Published var viewState = ViewState.loading
    @Published var footerViewState = StatefullFooterViewState.loading

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()
    let scrollToTopAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let videoId: String
    private let videoAPI: VideoAPIType
    private weak var delegate: VideoDetailViewModelDelegate?

    // MARK: Private

    private var pageSize = 20
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
                    self.commentCount = video.commentCount
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)

        loadMoreAction
            .filter { [weak self] in
                guard let self else { return false }
                return self.viewState != .loading && self.footerViewState != .noMoreData
            }
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[VideoComment], Error>().eraseToAnyPublisher()
                }
                return self.videoAPI.getVideoComments(
                    videoId: self.videoId,
                    beforeCommentId: self.comments.last?.id,
                    limit: self.pageSize
                )
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(comments):
                    self.comments.append(contentsOf: comments)
                    if comments.count < self.pageSize {
                        self.footerViewState = .noMoreData
                    } else {
                        self.footerViewState = .loading
                    }
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: VideoDetailInputViewModelDelegate

extension VideoDetailViewModel: VideoDetailInputViewModelDelegate {
    func didCommentSuccess(_ comment: VideoComment) {
        comments.insert(comment, at: 0)
        commentCount = commentCount.flatMap { $0 + 1 }
        scrollToTopAction.send()
    }
}
