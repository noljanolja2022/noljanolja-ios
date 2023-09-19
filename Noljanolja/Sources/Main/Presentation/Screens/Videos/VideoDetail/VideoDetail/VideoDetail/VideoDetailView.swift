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

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        switch viewModel.contentType {
        case .maximize, .minimize:
            buildContainerView()
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
        case .hide:
            EmptyView()
        }
    }

    private func buildContainerView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()
            buildMainView()
        }
        .frame(maxWidth: .infinity)
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
        .padding(
            .bottom,
            {
                switch viewModel.contentType {
                case .minimize: return viewModel.minimizeBottomPadding
                case .maximize, .hide: return 0
                }
            }()
        )
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        switch viewModel.contentType {
        case .maximize:
            HStack {
                Button(
                    action: {
                        viewModel.updateContentType(.minimize)
                    },
                    label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .resizable()
                            .padding(8)
                            .frame(width: 44, height: 44)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )
                Spacer()
            }
            .frame(height: 44)
        case .minimize, .hide:
            EmptyView()
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

    @ViewBuilder
    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                buildPlayerView()
                buildMinimizeDetailView()
            }
            buildMaximizeDetailView()
        }
    }

    @ViewBuilder
    private func buildPlayerView() -> some View {
        YouTubePlayerView(viewModel.youTubePlayer) { state in
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error:
                Spacer()
            }
        }
        .frame(width: viewModel.contentType.playerWidth)
        .frame(height: viewModel.contentType.playerHeight)
//        .allowsHitTesting(
//            {
//                switch viewModel.contentType {
//                case .maximize: return true
//                case .minimize, .hide: return false
//                }
//            }()
//        )
    }

    @ViewBuilder
    private func buildMaximizeDetailView() -> some View {
        switch viewModel.contentType {
        case .maximize:
            buildMaximizeDetailContentView()
        case .minimize, .hide:
            EmptyView()
        }
    }

    @ViewBuilder
    private func buildMinimizeDetailView() -> some View {
        switch viewModel.contentType {
        case .minimize:
            buildMinimizeDetailContentView()
        case .maximize, .hide:
            EmptyView()
        }
    }

    private func buildMaximizeDetailContentView() -> some View {
        VStack(spacing: 0) {
            buildScrollView()
            buildInputView()
        }
    }

    private func buildMinimizeDetailContentView() -> some View {
        HStack {
            if let video = viewModel.video {
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
            }

            if let systemImageName = viewModel.youTubePlayerPlaybackState?.systemImageName {
                Image(systemName: systemImageName)
                    .resizable()
                    .padding(8)
                    .frame(width: 32, height: 32)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .onTapGesture {
                        viewModel.youTubePlayerPlaybackStateAction.send()
                    }
            }

            Button(
                action: {
                    viewModel.hide()
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
        .onTapGesture {
            viewModel.updateContentType(.maximize)
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

    @ViewBuilder
    private func buildInputView() -> some View {
        if let videoId = viewModel.videoId {
            VideoDetailInputView(
                viewModel: VideoDetailInputViewModel(
                    videoId: videoId,
                    delegate: viewModel
                )
            )
        }
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
