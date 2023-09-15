//
//  UncompleteVideosView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/08/2023.
//
//

import SwiftUI

// MARK: - UncompleteVideosView

struct UncompleteVideosView<ViewModel: UncompleteVideosViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildStatefullView()
            buildNavigationLinks()
        }.navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.uncompletedVideo)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildStatefullView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.models.isEmpty },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                let models = viewModel.models
                ForEach(models.indices, id: \.self) {
                    let model = models[$0]
                    let itemViewModel = UncompleteVideoItemViewModel(model)
                    CommonVideoItemView(
                        model: itemViewModel,
                        elementTypes: [.progress]
                    )
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewModel.navigationType = .videoDetail(model)
                    }
                }
            }
        }
    }

    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: {
                buildNavigationLinkDestinationView($0)
            },
            label: {
                EmptyView()
            }
        )
    }
}

extension UncompleteVideosView {
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

extension UncompleteVideosView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<UncompleteVideosNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .videoDetail(video):
            VideoDetailView(
                viewModel: VideoDetailViewModel(
                )
            )
        }
    }
}

// MARK: - UncompleteVideosView_Previews

struct UncompleteVideosView_Previews: PreviewProvider {
    static var previews: some View {
        UncompleteVideosView(viewModel: UncompleteVideosViewModel())
    }
}
