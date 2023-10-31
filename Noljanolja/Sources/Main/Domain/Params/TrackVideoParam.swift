//
//  TrackVideoParam.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//

import Foundation

struct TrackVideoParam: Encodable, Equatable {
    let videoId: String
    let event: VideoProgressEventType
    let trackIntervalMs: Int
    let durationMs: Int

    init?(videoId: String?,
          event: VideoProgressEventType?,
          trackIntervalMs: Int,
          durationMs: Int) {
        guard let videoId, let event else { return nil }
        self.videoId = videoId
        self.event = event
        self.trackIntervalMs = trackIntervalMs
        self.durationMs = durationMs
    }
}
