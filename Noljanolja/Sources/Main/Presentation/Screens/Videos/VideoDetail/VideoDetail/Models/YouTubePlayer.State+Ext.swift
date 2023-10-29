//
//  YouTubePlayer.State+Ext.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/09/2023.
//

import Foundation
import youtube_ios_player_helper

extension YTPlayerState {
    var systemImageName: String? {
        switch self {
        case .playing, .buffering: return "pause.fill"
        case .cued, .ended, .paused, .unstarted, .unknown: return "play.fill"
        @unknown default: return "play.fill"
        }
    }
}
