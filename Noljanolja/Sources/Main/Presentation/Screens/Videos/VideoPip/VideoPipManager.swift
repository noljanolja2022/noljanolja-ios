//
//  VideoManager.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/09/2023.
//

import Combine
import Foundation
import YouTubePlayerKit

final class VideoManager {
    static let shared = VideoManager()

    let isHiddenSubject = CurrentValueSubject<Bool, Never>(true)
    let youTubePlayerSubject = CurrentValueSubject<YouTubePlayer?, Never>(nil)

    func createYouTubePlayer(with url: String) -> YouTubePlayer {
        if let youTubePlayer = youTubePlayerSubject.value,
           youTubePlayer.source?.id == YouTubePlayer.Source.url(url)?.id {
            return youTubePlayer
        }

        let youTubePlayer = YouTubePlayer(source: .url(url))
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

        youTubePlayerSubject.send(youTubePlayer)
        
        return youTubePlayer
    }
}
