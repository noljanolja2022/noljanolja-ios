//
//  VideoDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - VideoDetailView

struct VideoDetailView<ViewModel: VideoDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.videoTitle)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildContentView() -> some View {
        buildMainView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.video == nil },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    private func buildMainView() -> some View {
        VStack(spacing: 0) {
            buildPlayerView()
            buildScrollView()
            buildInputView()
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.video == nil },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
    }

    @ViewBuilder
    private func buildPlayerView() -> some View {
        if let video = viewModel.video {
            VideoDetailPlayerView(
                viewModel: VideoDetailPlayerViewModel(
                    video: video
                )
            )
        }
    }

    @ViewBuilder
    private func buildScrollView() -> some View {
        let topViewId = "top_view"
        ScrollViewReader { scrollView in
            ScrollView {
                LazyVStack(spacing: 4) {
                    if let video = viewModel.video {
                        VideoDetailInformationView(
                            video: video,
                            commentCount: viewModel.commentCount
                        )
                        .id(topViewId)
                    }

                    Divider()
                        .frame(height: 2)
                        .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                        .padding(.vertical, 4)

                    VideoDetailCommentsView(
                        comments: viewModel.comments,
                        footterViewState: $viewModel.footerViewState,
                        loadMoreAction: {
                            viewModel.loadMoreAction.send()
                        }
                    )
                }
                .padding(.top, 12)
            }
            .onReceive(viewModel.scrollToTopAction) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scrollView.scrollTo(topViewId, anchor: .top)
                }
            }
        }
    }

    private func buildInputView() -> some View {
        VideoDetailInputView(
            viewModel: VideoDetailInputViewModel(
                videoId: viewModel.videoId,
                delegate: viewModel
            )
        )
    }
}

extension VideoDetailView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildErrorView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

extension VideoDetailView {
    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<VideoDetailFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .webView(url):
            SafariView(url: url)
        }
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