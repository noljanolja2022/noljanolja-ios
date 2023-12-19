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
    let durationPublisher = PassthroughSubject<Double, Never>()

    // MARK: Dependencies

    private let videoNetworkRepository: VideoNetworkRepository
    private let videoSocket: VideoSocketAPIType
    private let videoUseCases: VideoUseCases
    private weak var delegate: VideoDetailViewModelDelegate?

    // MARK: Private

    private var pictureInPictureState: String?
    private let currentTimeSubject = CurrentValueSubject<Double?, Never>(nil)

    private var pageSize = 20
    private var cancellables = Set<AnyCancellable>()
    private var videoCancellables = Set<AnyCancellable>()

    init(videoNetworkRepository: VideoNetworkRepository = VideoNetworkRepositoryImpl.shared,
         videoSocket: VideoSocketAPIType = VideoSocketAPI.default,
         videoUseCases: VideoUseCases = VideoUseCasesImpl.shared,
         delegate: VideoDetailViewModelDelegate? = nil,
         videoId: String? = nil) {
        self.videoNetworkRepository = videoNetworkRepository
        self.videoSocket = videoSocket
        self.videoUseCases = videoUseCases
        self.delegate = delegate
        self.videoId = videoId
        super.init()

        configure()
    }

    func show(videoId: String,
              configuration: VideoDetailConfiguration? = nil,
              contentType: VideoDetailViewContentType = .full) {
        // For reopen last video
        if self.videoId == videoId {
            switch pictureInPictureState {
            case "picture-in-picture":
                break
            default:
                youtubePlayerView.seek(toSeconds: 0, allowSeekAhead: true)
                youtubePlayerView.playVideo()
            }
        }

        self.videoId = videoId
        self.configuration = configuration
        updateContentType(contentType)
    }

    func updateContentType(_ value: VideoDetailViewContentType) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.easeInOut(duration: 0.3)) {
                self?.contentType = value
            }
        }

        switch value {
        case .full:
            stopPictureInPicture()
        case .pictureInPicture:
            startPictureInPicture()
        case .bottom, .hide:
            break
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
            switch pictureInPictureState {
            case "picture-in-picture":
                break
            default:
                youtubePlayerView.pictureInPicture()
            }
        } else {
            updateContentType(.bottom)
        }
    }

    func stopPictureInPicture() {
        switch pictureInPictureState {
        case "picture-in-picture":
            youtubePlayerView.pictureInPicture()
            pictureInPictureState = "inline"
        default:
            break
        }
    }

    func switchPictureInPicture() {
        youtubePlayerView.pictureInPicture()
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
                return self.videoNetworkRepository.getVideoDetail(id: videoId)
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
        configureYoutubePlayer(video)
    }

    private func setVideo(_ video: Video) {
        youtubePlayerView.load(withVideoId: video.id, playerVars: ["autoplay": 1, "playsinline": 1])

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
                return self.videoNetworkRepository.getVideoComments(
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

    private func configureYoutubePlayer(_ video: Video) {
        youTubePlayerPlaybackStateAction
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                switch youtubePlayerState {
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
            $youtubePlayerState
                .compactMap { $0 },
            currentTimePublisher(updateInterval: 10)
                .map { _ in YTPlayerState.playing }
        )
        .withLatestFrom(
            Publishers.CombineLatest(
                currentTimePublisher(),
                durationPublisher
            )
        ) { (playbackState: YTPlayerState, times: (Double, Double)) in
            (playbackState, times.0, times.1)
        }
        .compactMap { state, currentTime, durationTime -> TrackVideoParam? in
            let trackIntervalMs = {
                switch state {
                case .ended: return Int(durationTime * 1000)
                case .playing, .paused, .unstarted, .buffering, .cued, .unknown: return Int(currentTime * 1000)
                @unknown default: return Int(currentTime * 1000)
                }
            }()
            return TrackVideoParam(
                videoId: video.id,
                event: state.trackEventType,
                trackIntervalMs: trackIntervalMs,
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
            self.$youtubePlayerState
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
}

// MARK: YTPlayerViewDelegate

extension VideoDetailViewModel: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.duration { [weak self] result, _ in
            guard let self else { return }
            self.durationPublisher.send(result)
        }
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
        youtubePlayerState = state
    }

    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        currentTimeSubject.send(Double(playTime))
    }

    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {}

    func playerView(_ playerView: YTPlayerView, didChangeToStatePictureInPicture state: String?) {
        pictureInPictureState = state
        switch state {
        case "picture-in-picture", "inlineleave":
            break
        default:
            updateContentType(.full)
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
