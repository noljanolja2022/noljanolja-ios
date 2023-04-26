//
//  VideoDetailPlayerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI
import YouTubePlayerKit

struct VideoDetailPlayerView: View {
    var video: Video

    private let youTubePlayer: YouTubePlayer

    init(video: Video) {
        self.video = video

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

        self.youTubePlayer = youTubePlayer
    }

    var body: some View {
        YouTubePlayerView(self.youTubePlayer) { state in
            // Overlay ViewBuilder closure to place an overlay View
            // for the current `YouTubePlayer.State`
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case let .error(error):
                Text(verbatim: "YouTube player couldn't be loaded")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.width * 5 / 9.0)
    }
}
