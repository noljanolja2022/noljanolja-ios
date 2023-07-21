//
//  VideosModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import Foundation

struct VideosModel {
    let highlightVideos: [Video]
    let watchingVideos: [Video]
    let trendingVideos: [Video]

    init(highlightVideos: [Video] = [],
         watchingVideos: [Video] = [],
         trendingVideos: [Video] = []) {
        self.highlightVideos = highlightVideos
        self.watchingVideos = watchingVideos
        self.trendingVideos = trendingVideos
    }

    var isEmpty: Bool {
        highlightVideos.isEmpty && watchingVideos.isEmpty && trendingVideos.isEmpty
    }
}
