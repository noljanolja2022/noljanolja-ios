//
//  YouTubePlayer.State+Ext.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/09/2023.
//

import Foundation
import YouTubePlayerKit

extension YouTubePlayer.PlaybackState {
    var systemImageName: String? {
        switch self {
        case .playing, .buffering: return "pause.fill"
        case .cued, .ended, .paused, .unstarted: return "play.fill"
        }
    }
}
