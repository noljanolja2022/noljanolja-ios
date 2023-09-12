//
//  VideoDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//
//

import Combine
import Foundation
import Moya
import YouTubePlayerKit

// MARK: - VideoDetailViewModelDelegate

protocol VideoDetailViewModelDelegate: AnyObject {}

// MARK: - VideoDetailViewModel

final class VideoDetailViewModel: ViewModel {
    // MARK: State

    @Published var video: Video?
    @Published var youTubePlayer: YouTubePlayer?
    @Published var comments = [VideoComment]()
    @Published var commentCount: Int?
    @Published var viewState = ViewState.loading
    @Published var footerViewState = StatefullFooterViewState.loading

    // MARK: Navigations

    @Published var fullScreenCoverType: VideoDetailFullScreenCoverType?

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()
    let loadMoreAction = PassthroughSubject<Void, Never>()
    let scrollToTopAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let videoId: String
    private let videoManager: VideoManager
    private let videoRepository: VideoRepository
    private let videoSocket: VideoSocketAPIType
    private weak var delegate: VideoDetailViewModelDelegate?

    // MARK: Private

    private var pageSize = 20
    private var playerCancellables = Set<AnyCancellable>()
    private var cancellables = Set<AnyCancellable>()

    init(videoId: String,
         videoManager: VideoManager = VideoManager.shared,
         videoRepository: VideoRepository = VideoRepositoryImpl.shared,
         videoSocket: VideoSocketAPIType = VideoSocketAPI.default,
         delegate: VideoDetailViewModelDelegate? = nil) {
        self.videoId = videoId
        self.videoManager = videoManager
        self.videoRepository = videoRepository
        self.videoSocket = videoSocket
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<Video, Error> in
                guard let self else {
                    return Empty<Video, Error>().eraseToAnyPublisher()
                }
                return self.videoRepository.getVideoDetail(id: self.videoId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(video):
                    self.video = video
                    self.youTubePlayer = self.initYouTubePlayer(video)
                    self.comments = video.comments
                    self.commentCount = video.commentCount
                    
                    self.viewState = .content
                    if video.comments.count < self.pageSize {
                        self.footerViewState = .noMoreData
                    } else {
                        self.footerViewState = .loading
                    }
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)

        loadMoreAction
            .receive(on: DispatchQueue.main)
            .filter { [weak self] in
                guard let self else { return false }
                return self.viewState != .loading && self.footerViewState != .noMoreData
            }
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[VideoComment], Error>().eraseToAnyPublisher()
                }
                return self.videoRepository.getVideoComments(
                    videoId: self.videoId,
                    beforeCommentId: self.comments.last?.id,
                    limit: self.pageSize
                )
            }
            .receive(on: DispatchQueue.main)
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

    private func configureActions() {
        closeAction
            .sink { [weak self] in
                self?.videoManager.selecttedVideoIdSubject.send(nil)
            }
            .store(in: &cancellables)

        $youTubePlayer
            .compactMap { $0 }
            .sink { [weak self] in
                self?.configurePlayer($0)
            }
            .store(in: &cancellables)
    }

    private func configurePlayer(_ youTubePlayer: YouTubePlayer) {
        let video = video

        playerCancellables.removeAll()

        Publishers.Merge(
            youTubePlayer.playbackStatePublisher,
            youTubePlayer.currentTimePublisher(updateInterval: 10)
                .map { _ in YouTubePlayer.PlaybackState.playing }
        )
        .withLatestFrom(
            Publishers.CombineLatest(
                youTubePlayer.currentTimePublisher(),
                youTubePlayer.durationPublisher
            )
        ) { ($0, $1.0, $1.1) }
        .compactMap { state, currentTime, durationTime -> TrackVideoParam? in
            TrackVideoParam(
                videoId: video?.id,
                event: state.trackEventType,
                trackIntervalMs: Int(currentTime * 1000),
                durationMs: Int(durationTime * 1000)
            )
        }
        .compactMap { try? $0.jsonString() }
        .sink(receiveValue: { [weak self] in
            self?.videoSocket.trackVideoProgress(data: $0)
        })
        .store(in: &playerCancellables)
    }
}

extension VideoDetailViewModel {
    private func initYouTubePlayer(_ video: Video) -> YouTubePlayer? {
        let youTubePlayer = YouTubePlayer(source: .url(video.url))
        youTubePlayer.configuration = YouTubePlayer.Configuration(
            automaticallyAdjustsContentInsets: nil,
            allowsPictureInPictureMediaPlayback: nil,
            fullscreenMode: .system,
            openURLAction: .default,
            autoPlay: true, // Updated
            captionLanguage: nil,
            showCaptions: false, // Updated
            progressBarColor: nil,
            showControls: nil,
            keyboardControlsDisabled: nil,
            enableJavaScriptAPI: true, // Updated
            endTime: nil,
            showFullscreenButton: nil,
            language: nil,
            showAnnotations: nil,
            loopEnabled: nil,
            useModestBranding: false, // Updated
            playInline: true, // Updated
            showRelatedVideos: nil,
            startTime: nil,
            referrer: nil,
            customUserAgent: nil
        )
        youTubePlayer.hideStatsForNerds()
        return youTubePlayer
    }
}

// MARK: VideoDetailInputViewModelDelegate

extension VideoDetailViewModel: VideoDetailInputViewModelDelegate {
    func videoDetailInputViewModel(didCommentSuccess comment: VideoComment) {
        comments.insert(comment, at: 0)
        commentCount = commentCount.flatMap { $0 + 1 }
        scrollToTopAction.send()
    }

    func videoDetailInputViewModel(didCommentFail error: Error) {
        switch error as? MoyaError {
        case let .underlying(_, response):
            guard let data = response?.data,
                  let baseResponse = BaseResponse(from: data),
                  baseResponse.code == 400014,
                  let url = URL(string: "https://support.google.com/youtube/answer/1646861?topic=3024170&hl=en") else { return }
            fullScreenCoverType = .webView(url)
        default:
            break
        }
    }
}
