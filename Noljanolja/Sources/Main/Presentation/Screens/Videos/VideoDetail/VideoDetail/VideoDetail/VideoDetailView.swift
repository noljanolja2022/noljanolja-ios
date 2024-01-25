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

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        buildContentTypeView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    @ViewBuilder
    private func buildContentTypeView() -> some View {
        switch viewModel.contentType {
        case .full, .bottom, .pictureInPicture:
            buildNavigationView()
        case .hide:
            EmptyView()
        }
    }

    private func buildNavigationView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()
            buildMainView()
        }
        .frame(maxWidth: .infinity)
        .background(ColorAssets.primaryGreen200.swiftUIColor.ignoresSafeArea())
        .padding(
            .bottom,
            {
                switch viewModel.contentType {
                case .bottom: return viewModel.minimizeBottomPadding
                case .full, .pictureInPicture, .hide: return 0
                }
            }()
        )
        .zIndex({
            switch viewModel.contentType {
            case .full, .bottom: return 2
            case .pictureInPicture, .hide: return 0
            }
        }())
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        switch viewModel.contentType {
        case .full, .pictureInPicture:
            ZStack {
                HStack(spacing: 4) {
                    Button(
                        action: {
                            viewModel.youtubePlayerView.playVideo()
                            viewModel.updateContentType(.pictureInPicture)
                        },
                        label: {
                            ImageAssets.icBack.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, 16)
                                .padding(.vertical, 14)
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        }
                    )
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(ColorAssets.primaryGreen200.swiftUIColor)
                HStack {
                    Spacer()
                    Text(L10n.videoTitle)
                        .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.clear)
            }
        case .bottom, .hide:
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
                buildHorizontalDetailView()
            }
            buildVerticalDetailView()
        }
        .background(ColorAssets.neutralLight.swiftUIColor.edgesIgnoringSafeArea(.bottom))
    }

    @ViewBuilder
    private func buildPlayerView() -> some View {
        YoutubePlayerView(viewModel.youtubePlayerView)
            .frame(width: viewModel.contentType.playerWidth)
            .frame(height: viewModel.contentType.playerHeight)
    }

    @ViewBuilder
    private func buildHorizontalDetailView() -> some View {
        switch viewModel.contentType {
        case .full, .pictureInPicture, .hide:
            EmptyView()
        case .bottom:
            buildHorizontalDetailContentView()
        }
    }

    @ViewBuilder
    private func buildVerticalDetailView() -> some View {
        switch viewModel.contentType {
        case .full, .pictureInPicture:
            buildVerticalDetailContentView()
        case .bottom, .hide:
            EmptyView()
        }
    }

    private func buildHorizontalDetailContentView() -> some View {
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

            if let systemImageName = viewModel.youtubePlayerState?.systemImageName {
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
                    viewModel.updateContentType(.hide)
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
            viewModel.updateContentType(.full)
        }
    }

    private func buildVerticalDetailContentView() -> some View {
        VStack(spacing: 0) {
            buildScrollView()
            buildInputView()
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
                            commentCount: viewModel.commentCount,
                            didTapLikeButton: { viewModel.likeVideoAction.send($0) }
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
