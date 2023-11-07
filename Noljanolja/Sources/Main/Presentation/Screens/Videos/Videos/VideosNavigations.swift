//
//  VideosNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//

import Foundation

// MARK: - VideosNavigationType

enum VideosNavigationType: Equatable {
    case uncompleteVideos
    case searchVideo
}

// MARK: - VideosFullScreenCoverType

enum VideosFullScreenCoverType: Equatable {
    case more(Video)
}
