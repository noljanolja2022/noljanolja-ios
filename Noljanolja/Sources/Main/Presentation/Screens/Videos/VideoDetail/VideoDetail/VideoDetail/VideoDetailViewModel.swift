//
//  VideoDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//
//

import AVKit
import Combine
import Foundation
import Moya
import SwiftUIX
import youtube_ios_player_helper
import YouTubePlayerKit

// MARK: - VideoDetailViewModelDelegate

protocol VideoDetailViewModelDelegate: AnyObject {}

// MARK: - VideoDetailViewModel

final class VideoDetailViewModel: ViewModel {
    static let shared = VideoDetailViewModel()

    // MARK: State

    lazy var youtubePlayerView: YTPlayerView = {
        let youtubePlayerView = YTPlayerView()
        youtubePlayerView.delegate = self
        return youtubePlayerView
    }()

    @Published private(set) var videoId: String?
    @Published private var configuration: VideoDetailConfiguration?
    @Published private(set) var contentType = VideoDetailViewContentType.hide
    @Published private(set) var minimizeBottomPadding: CGFloat = 0

    @Published var video: Video?
    @Published var comments = [VideoComment]()
    @Published var commentCount: Int?

    @Published var youtubePlayerState: YTPlayerState?

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
    private let videoUseCases: VideoUseCases
    private weak var delegate: VideoDetailViewModelDelegate?

    // MARK: Private
    
    private let playbackStateSubject = CurrentValueSubject<YTPlayerState?, Never>(nil)
    private let currentTimeSubject = CurrentValueSubject<Double?, Never>(nil)

    private var pageSize = 20
    private var cancellables = Set<AnyCancellable>()
    private var videoCancellables = Set<AnyCancellable>()

    init(videoRepository: VideoRepository = VideoRepositoryImpl.shared,
         videoSocket: VideoSocketAPIType = VideoSocketAPI.default,
         videoUseCases: VideoUseCases = VideoUseCasesImpl.shared,
         delegate: VideoDetailViewModelDelegate? = nil) {
        self.videoRepository = videoRepository
        self.videoSocket = videoSocket
        self.videoUseCases = videoUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    func show(videoId: String,
              configuration: VideoDetailConfiguration? = nil,
              contentType: VideoDetailViewContentType = .full) {
        self.videoId = videoId
        self.configuration = configuration
        updateContentType(contentType)
    }

    func hide() {
        youtubePlayerView.stopVideo()

        videoId = nil
        updateContentType(.hide)
        stopPictureInPicture()
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
    
    func startPictureInPicture() {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            youtubePlayerView.requestPicture { [weak self] state, _ in
                switch state {
                case "picture_in_picture": break
                default: self?.youtubePlayerView.pictureInPicture()
                }
            }
        } else {
            updateContentType(.bottom)
        }
    }
    
    func stopPictureInPicture() {
        youtubePlayerView.requestPicture { [weak self] state, _ in
            switch state {
            case "picture_in_picture": self?.youtubePlayerView.pictureInPicture()
            default: break
            }
        }
    }

    private func configure() {
        configureLoadData()
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
                    self.configureVideo(video)
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
    }

    private func configureVideo(_ video: Video) {
        videoCancellables = Set<AnyCancellable>()
        setVideo(video)
        configureActions()
        configureYouTubePlayer(video)
    }

    private func setVideo(_ video: Video) {
        youtubePlayerView.load(withVideoId: video.id)

        self.video = video
        comments = video.comments
        commentCount = video.commentCount

        viewState = .content
        if video.comments.count < pageSize {
            footerViewState = .noMoreData
        } else {
            footerViewState = .loading
        }
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
            .store(in: &videoCancellables)
    }

    private func configureYouTubePlayer(_ video: Video) {
        playbackStateSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.youtubePlayerState = $0
            })
            .store(in: &videoCancellables)

        youTubePlayerPlaybackStateAction
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                switch playbackStateSubject.value {
                case .buffering, .cued, .paused, .unstarted:
                    youtubePlayerView.playVideo()
                case .ended:
                    youtubePlayerView.seek(toSeconds: 0, allowSeekAhead: true)
                    youtubePlayerView.playVideo()
                case .playing:
                    youtubePlayerView.pauseVideo()
                case .unknown, .none:
                    break
                @unknown default:
                    break
                }
            })
            .store(in: &videoCancellables)

        currentTimePublisher()
            .first(where: { [weak self] currentTime in
                guard let configuration = self?.configuration else {
                    return false
                }
                return currentTime >= configuration.autoActionDuration
            })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Fail<Void, Error>(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.videoUseCases
                    .reactPromote(videoId: video.id)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)
        
        Publishers.Merge(
            playbackStateSubject
                .compactMap { $0 },
            currentTimePublisher(updateInterval: 10)
                .map { _ in YTPlayerState.playing }
        )
        .withLatestFrom(
            Publishers.CombineLatest(
                currentTimePublisher(),
                durationPublisher()
            )
        ) { (playbackState: YTPlayerState, times: (Double, Double)) in
            (playbackState, times.0, times.1)
        }
        .compactMap { state, currentTime, durationTime -> TrackVideoParam? in
            TrackVideoParam(
                videoId: video.id,
                event: state.trackEventType,
                trackIntervalMs: Int(currentTime * 1000),
                durationMs: Int(durationTime * 1000)
            )
        }
        .compactMap { try? $0.jsonString() }
        .sink(receiveValue: { [weak self] in
            self?.videoSocket.trackVideoProgress(data: $0)
        })
        .store(in: &videoCancellables)
    }
}

extension VideoDetailViewModel {
    private func currentTimePublisher(updateInterval: TimeInterval = 0.5) -> AnyPublisher<Double, Never> {
        Publishers.Merge(
            Just(()),
            Timer
                .publish(every: updateInterval, on: .main, in: .common)
                .autoconnect()
                .mapToVoid()
        )
        .flatMap {
            self.playbackStateSubject
                .filter { $0 == .playing }
                .removeDuplicates()
        }
        .flatMap { _ in
            self.currentTimeSubject
                .compactMap { $0 }
                .removeDuplicates()
                .first()
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
    
    private func durationPublisher() -> AnyPublisher<Double, Never> {
        Future { [weak self] promise in
            self?.youtubePlayerView.duration { duration, _ in
                promise(.success(duration))
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: YTPlayerViewDelegate

extension VideoDetailViewModel: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
        switch contentType {
        case .full, .bottom, .hide:
            break
        case .pictureInPicture:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.startPictureInPicture()
            }
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        playbackStateSubject.send(state)
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        currentTimeSubject.send(Double(playTime))
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {}
    
    func playerView(_ playerView: YTPlayerView, didChangeToStatePictureInPicture state: String?) {
        switch state {
        case "picture_in_picture":
            updateContentType(.pictureInPicture)
        default:
            switch contentType {
            case .pictureInPicture:
                updateContentType(.hide)
            case .full, .bottom, .hide:
                break
            }
        }
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
