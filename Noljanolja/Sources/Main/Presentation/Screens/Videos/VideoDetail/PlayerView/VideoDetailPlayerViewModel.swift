//
//  VideoDetailPlayerViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//
//

import Combine
import Foundation
import YouTubePlayerKit

// MARK: - VideoDetailPlayerViewModelDelegate

protocol VideoDetailPlayerViewModelDelegate: AnyObject {}

// MARK: - VideoDetailPlayerViewModel

final class VideoDetailPlayerViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private let video: Video
    private let videoSocket: VideoSocketAPIType
    private weak var delegate: VideoDetailPlayerViewModelDelegate?

    // MARK: Private

    lazy var youTubePlayer = initYouTubePlayer()
    private var cancellables = Set<AnyCancellable>()

    init(video: Video,
         videoSocket: VideoSocketAPIType = VideoSocketAPI.default,
         delegate: VideoDetailPlayerViewModelDelegate? = nil) {
        self.video = video
        self.videoSocket = videoSocket
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        let video = video

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
        .store(in: &cancellables)
    }
}

extension VideoDetailPlayerViewModel {
    private func initYouTubePlayer() -> YouTubePlayer {
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
