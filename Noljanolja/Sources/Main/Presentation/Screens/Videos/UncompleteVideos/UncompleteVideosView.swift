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

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildStatefullView()
            buildNavigationLinks()
        }
        .navigationBar(title: L10n.uncompletedVideo, backButtonTitle: "", presentationMode: presentationMode, trailing: {})
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
                        VideoDetailViewModel.shared.show(videoId: model.id)
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
        _: Binding<UncompleteVideosNavigationType>
    ) -> some View {}
}

// MARK: - UncompleteVideosView_Previews

struct UncompleteVideosView_Previews: PreviewProvider {
    static var previews: some View {
        UncompleteVideosView(viewModel: UncompleteVideosViewModel())
    }
}
