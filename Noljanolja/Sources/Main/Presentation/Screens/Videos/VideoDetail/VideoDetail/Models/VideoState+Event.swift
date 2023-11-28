//
//  VideoState+Event.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//

import Foundation
import youtube_ios_player_helper

extension YTPlayerState {
    var trackEventType: VideoProgressEventType? {
        switch self {
        case .playing, .ended: return .play
        case .paused: return .pause
        case .unstarted, .buffering, .cued, .unknown: return nil
        @unknown default: return nil
        }
    }
}
