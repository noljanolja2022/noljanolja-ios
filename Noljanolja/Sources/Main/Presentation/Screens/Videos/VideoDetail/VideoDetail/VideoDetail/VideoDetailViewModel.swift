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
import SwiftUIX
import YouTubePlayerKit

// MARK: - VideoDetailViewModelDelegate

protocol VideoDetailViewModelDelegate: AnyObject {}

// MARK: - VideoDetailViewModel

final class VideoDetailViewModel: ViewModel {
    static let shared = VideoDetailViewModel()

    // MARK: State

    lazy var youTubePlayerConfiguration = YouTubePlayer.Configuration(
        automaticallyAdjustsContentInsets: nil,
        allowsPictureInPictureMediaPlayback: true,
        fullscreenMode: .system,
        openURLAction: .init(handler: { _ in }), // Updated
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

    lazy var youTubePlayer: YouTubePlayer = {
        let youTubePlayer = YouTubePlayer()
        youTubePlayer.configuration = youTubePlayerConfiguration
        youTubePlayer.hideStatsForNerds()
        return youTubePlayer
    }()

    @Published private(set) var videoId: String?
    @Published private(set) var contentType = VideoDetailViewContentType.hide
    @Published private(set) var minimizeBottomPadding: CGFloat = 0

    @Published var video: Video?
    @Published var comments = [VideoComment]()
    @Published var commentCount: Int?

    @Published var youTubePlayerPlaybackState: YouTubePlayer.PlaybackState?

    @Published var viewState = ViewState.loading
    @Published var footerViewState = StatefullFooterViewState.loading

    // MARK: Navigations

    @Published var fullScreenCoverType: VideoDetailFullScreenCoverType?

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()
    let scrollToTopAction = PassthroughSubject<Void, Never>()
    let youTubePlayerPlaybackStateAction = PassthroughSubject<Void, Never>()

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
        case .maximize, .minimize:
            break
        case .hide:
            updateContentType(.maximize)
        }
    }

    func hide() {
        youTubePlayer.source = nil

        videoId = nil
        updateContentType(.hide)
    }

    func updateContentType(_ value: VideoDetailViewContentType) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.easeInOut(duration: 0.3)) {
                self?.contentType = value
            }
        }
    }

    func updateMinimizeBottomPadding(_ value: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.easeInOut(duration: 0.3)) {
                self?.minimizeBottomPadding = value
            }
        }
    }

    private func configure() {
        configureLoadData()
        configureActions()
        configureYouTubePlayer()
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
                    self.youTubePlayer.source = .url(video.url)

                    self.video = video
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
    }

    private func configureActions() {
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

    private func configureYouTubePlayer() {
        youTubePlayer.playbackStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.youTubePlayerPlaybackState = $0
            })
            .store(in: &cancellables)

        youTubePlayerPlaybackStateAction
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                switch youTubePlayer.playbackState {
                case .buffering, .cued, .paused, .unstarted:
                    youTubePlayer.play()
                case .ended:
                    youTubePlayer.seek(to: 0, allowSeekAhead: true)
                    youTubePlayer.play()
                case .playing:
                    youTubePlayer.pause()
                case .none:
                    break
                }
            })
            .store(in: &cancellables)

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
