//
//  VideoDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//
//

import SwiftUI

// MARK: - VideoDetailView

struct VideoDetailView<ViewModel: VideoDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Let’s get points by watching")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
    }

    private func buildMainView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.video == nil },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    private func buildContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                if let video = viewModel.video {
                    VideoDetailPlayerView(video: video)
                    VideoDetailInformationView(video: video)
                }

                Divider()
                    .frame(height: 2)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                    .padding(.vertical, 4)

                VideoDetailCommentsView(comments: viewModel.comments)
            }
        }
    }

    private func buildLoadingView() -> some View {
        LoadingView()
    }

    private func buildEmptyView() -> some View {
        Text("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        Text("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - VideoDetailView_Previews

struct VideoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetailView(
            viewModel: VideoDetailViewModel(
                videoId: ""
            )
        )
    }
}
