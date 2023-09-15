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
    static let shared = VideoDetailViewModel()

    // MARK: State

    lazy var youTubePlayer: YouTubePlayer = {
        let youTubePlayer = YouTubePlayer()
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
    }()

    @Published var videoId: String?
    @Published var video: Video?
    @Published var comments = [VideoComment]()
    @Published var commentCount: Int?
    @Published var contentType = VideoDetailViewContentType.hide
    @Published var viewState = ViewState.loading
    @Published var footerViewState = StatefullFooterViewState.loading

    // MARK: Navigations

    @Published var fullScreenCoverType: VideoDetailFullScreenCoverType?

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()
    let scrollToTopAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let videoRepository: VideoRepository
    private let videoSocket: VideoSocketAPIType
    private weak var delegate: VideoDetailViewModelDelegate?

    // MARK: Private

    private var pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(videoRepository: VideoRepository = VideoRepositoryImpl.shared,
         videoSocket: VideoSocketAPIType = VideoSocketAPI.default,
         delegate: VideoDetailViewModelDelegate? = nil) {
        self.videoRepository = videoRepository
        self.videoSocket = videoSocket
        self.delegate = delegate
        super.init()

        configure()
    }

    func show(videoId: String) {
        self.videoId = videoId
        switch contentType {
        case .full, .minimize:
            break
        case .hide:
            contentType = .full
        }
    }

    func hide() {
        videoId = nil
        contentType = .hide
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        $videoId
            .removeDuplicates()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] videoId -> AnyPublisher<Video, Error> in
                guard let self else {
                    return Empty<Video, Error>().eraseToAnyPublisher()
                }
                return self.videoRepository.getVideoDetail(id: videoId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(video):
                    self.video = video
                    self.youTubePlayer.source = .url(video.url)
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
            .withLatestFrom($videoId)
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { [weak self] _ in
                guard let self else { return false }
                return self.viewState != .loading && self.footerViewState != .noMoreData
            }
            .flatMapLatestToResult { [weak self] videoId in
                guard let self else {
                    return Empty<[VideoComment], Error>().eraseToAnyPublisher()
                }
                return self.videoRepository.getVideoComments(
                    videoId: videoId,
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
        .compactMap { [weak self] state, currentTime, durationTime -> TrackVideoParam? in
            TrackVideoParam(
                videoId: self?.video?.id,
                event: state.trackEventType,
                trackIntervalMs: Int(currentTime * 1000),
                durationMs: Int(durationTime * 1000)
            )
        }
        .compactMap { try? $0.jsonString() }
        .sink(receiveValue: { [weak self] in
            self?.videoSocket.trackVideoProgress(data: $0)
        })
        .store(in: &cancellables)
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
