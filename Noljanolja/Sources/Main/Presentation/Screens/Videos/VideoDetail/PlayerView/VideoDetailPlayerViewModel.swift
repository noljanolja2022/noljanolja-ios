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
    private let videoManager: VideoManager
    private weak var delegate: VideoDetailPlayerViewModelDelegate?

    // MARK: Private

    lazy var youTubePlayer = initYouTubePlayer()
    private var cancellables = Set<AnyCancellable>()

    init(video: Video,
         videoSocket: VideoSocketAPIType = VideoSocketAPI.default,
         videoManager: VideoManager = VideoManager.shared,
         delegate: VideoDetailPlayerViewModelDelegate? = nil) {
        self.video = video
        self.videoSocket = videoSocket
        self.videoManager = videoManager
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        let video = video

        isAppearSubject
            .dropFirst()
            .sink { [weak self] in
                self?.videoManager.isHiddenSubject.send($0)
            }
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
        videoManager.createYouTubePlayer(with: video.url)
    }
}
