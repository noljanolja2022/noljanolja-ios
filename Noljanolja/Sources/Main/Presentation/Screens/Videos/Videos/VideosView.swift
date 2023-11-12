//
//  VideosView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//
//

import AlertToast
import SwiftUI
import SwiftUIX

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
        .fullScreenCover(
            unwrapping: $viewModel.fullScreenCoverType,
            content: {
                buildFullScreenCoverDestinationView($0)
            }
        )
        .toast(isPresenting: $viewModel.isShowToastCopy, duration: 2, tapToDismiss: true) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .regular,
                title: "Link copied",
                style: .style(
                    backgroundColor: ColorAssets.neutralDarkGrey.swiftUIColor,
                    titleColor: ColorAssets.neutralLight.swiftUIColor
                )
            )
        }
    }

    private func buildContentView() -> some View {
        VStack {
            buildHeaderView()
            ScrollView {
                VStack(spacing: 8) {
                    buildWatchingView()
                    
                    Divider()
                        .frame(height: 2)
                        .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                        .padding(.vertical, 4)
                    
                    buildTrendingView()
                }
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
        .background(ColorAssets.neutralLight.swiftUIColor)
    }

    @ViewBuilder
    private func buildHighlightView() -> some View {
        if !viewModel.model.highlightVideos.isEmpty {
            HighlightVideoView(
                videos: viewModel.model.highlightVideos,
                selectAction: {
                    VideoDetailViewModel.shared.show(videoId: $0.id)
                }
            )
        }
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        HeaderVideoView(
            searchAction: {
                viewModel.navigationType = .searchVideo
            }
        )
    }

    @ViewBuilder
    private func buildWatchingView() -> some View {
        if !viewModel.model.watchingVideos.isEmpty {
            WatchingVideoView(
                videos: viewModel.model.watchingVideos,
                seeAllAction: {
                    viewModel.navigationType = .uncompleteVideos
                },
                selectAction: {
                    VideoDetailViewModel.shared.show(videoId: $0.id)
                }
            )
        }
    }

    @ViewBuilder
    private func buildTrendingView() -> some View {
        if !viewModel.model.trendingVideos.isEmpty {
            TrendingVideoView(
                models: viewModel.model.trendingVideos,
                selectAction: {
                    VideoDetailViewModel.shared.show(videoId: $0.id)
                },
                moreAction: { model in
                    withoutAnimation {
                        viewModel.fullScreenCoverType = .more(model)
                    }
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
}

extension VideosView {
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

extension VideosView {
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<VideosNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .uncompleteVideos:
            UncompleteVideosView(
                viewModel: UncompleteVideosViewModel()
            )
        case .searchVideo:
            SearchVideosView(
                viewModel: SearchVideosViewModel()
            )
        case let .chat(conversationId):
            ChatView(
                viewModel: ChatViewModel(
                    conversationID: conversationId
                )
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<VideosFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .more(model):
            VideoActionContainerView(
                viewModel: VideoActionContainerViewModel(
                    video: model,
                    delegate: viewModel
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
