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

    let selecttedVideoIdSubject = CurrentValueSubject<String?, Never>(nil)
}
