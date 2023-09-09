//
//  VideoDetailPlayerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//
//

import Combine
import SwiftUI
import YouTubePlayerKit

// MARK: VideoDetailPlayerView

struct VideoDetailPlayerView<ViewModel: VideoDetailPlayerViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        YouTubePlayerView(viewModel.youTubePlayer) { state in
            // Overlay ViewBuilder closure to place an overlay View
            // for the current `YouTubePlayer.State`
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error:
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.width * 5 / 9.0)
    }
}
