//
//  VideosView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//
//

import SwiftUI

// MARK: - VideosView

struct VideosView<ViewModel: VideosViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLink()
        }
        .clipped()
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                buildHighlightView()
                buildWatchingView()

                Divider()
                    .frame(height: 2)
                    .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                    .padding(.vertical, 4)

                buildTrendingView()
            }
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.model.isEmpty },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func buildHighlightView() -> some View {
        if !viewModel.model.highlightVideos.isEmpty {
            HighlightVideoView(
                videos: viewModel.model.highlightVideos,
                selectAction: {
                    viewModel.navigationType = .videoDetail($0)
                }
            )
        }
    }

    @ViewBuilder
    private func buildWatchingView() -> some View {
        if !viewModel.model.highlightVideos.isEmpty {
            WatchingVideoView(
                videos: viewModel.model.highlightVideos,
                selectAction: {
                    viewModel.navigationType = .videoDetail($0)
                }
            )
        }
    }

    @ViewBuilder
    private func buildTrendingView() -> some View {
        if !viewModel.model.trendingVideos.isEmpty {
            TrendingVideoView(
                videos: viewModel.model.trendingVideos,
                selectAction: {
                    viewModel.navigationType = .videoDetail($0)
                }
            )
        }
    }

    @ViewBuilder
    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { buildNavigationDestinationView($0) },
            label: {}
        )
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

    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<VideosNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .videoDetail(video):
            VideoDetailView(
                viewModel: VideoDetailViewModel(
                    videoId: video.id
                )
            )
        }
    }
}

// MARK: - VideosView_Previews

struct VideosView_Previews: PreviewProvider {
    static var previews: some View {
        VideosView(viewModel: VideosViewModel())
    }
}
