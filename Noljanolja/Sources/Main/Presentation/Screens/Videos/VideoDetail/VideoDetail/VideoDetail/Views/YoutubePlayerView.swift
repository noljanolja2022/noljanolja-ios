//
//  YoutubePlayerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/10/2023.
//

import Foundation
import SwiftUI
import youtube_ios_player_helper

struct YoutubePlayerView: UIViewRepresentable {
    private let playerView: YTPlayerView
        
    init(_ playerView: YTPlayerView) {
        self.playerView = playerView
    }
    
    func makeUIView(context: Context) -> YTPlayerView {
        playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {}
}
