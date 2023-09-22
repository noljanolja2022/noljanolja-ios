//
//  VideoState+Event.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//

import Foundation
import YouTubePlayerKit

extension YouTubePlayer.PlaybackState {
    var trackEventType: VideoProgressEventType? {
        switch self {
        case .playing: return .play
        case .paused: return .pause
        case .ended: return .finish
        case .unstarted, .buffering, .cued: return nil
        }
    }
}
