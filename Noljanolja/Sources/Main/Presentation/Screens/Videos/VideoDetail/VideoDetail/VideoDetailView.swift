//
//  VideoDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//
//

import SwiftUI
import SwiftUIX
import YouTubePlayerKit

// MARK: - VideoDetailView

struct VideoDetailView<ViewModel: VideoDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    @State private var isFull = true

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
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

    private func buildMainView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()
            buildDetailView()
        }
        .frame(maxWidth: .infinity)
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        if isFull {
            HStack {
                Button(
                    action: {
                        isFull = !isFull
                    },
                    label: {
                        ImageAssets.icClose.swiftUIImage
                            .resizable()
                            .padding(8)
                            .frame(width: 32, height: 32)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )
                Spacer()
            }
            .frame(height: 32)
        }
    }

    private func buildDetailView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.video == nil },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildMiniView()
            if isFull {
                buildScrollView()
                buildInputView()
            }
        }
    }

    private func buildMiniView() -> some View {
        HStack(spacing: 16) {
            buildPlayerView()

            if !isFull, let video = viewModel.video {
                VStack(spacing: 4) {
                    Text(video.title ?? "")
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                    if let channelTitle = video.channel?.title, !channelTitle.isEmpty {
                        Text(channelTitle)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .dynamicFont(.systemFont(ofSize: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    }
                }

                Button(
                    action: {},
                    label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .padding(8)
                            .frame(width: 32, height: 32)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )

                Button(
                    action: {
                        viewModel.closeAction.send()
                    },
                    label: {
                        ImageAssets.icClose.swiftUIImage
                            .resizable()
                            .padding(8)
                            .frame(width: 32, height: 32)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )
            }
        }
    }

    @ViewBuilder
    private func buildPlayerView() -> some View {
        if let youTubePlayer = viewModel.youTubePlayer {
            YouTubePlayerView(youTubePlayer) { state in
                switch state {
                case .idle:
                    ProgressView()
                case .ready:
                    EmptyView()
                case .error:
                    Spacer()
                }
            }
            .frame(width: isFull ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 3.0)
            .frame(height: (isFull ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 3.0) * (5.0 / 9.0))
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
