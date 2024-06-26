//
//  MessageImagesView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/07/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - MessageImagesView

struct MessageImagesView<ViewModel: MessageImagesViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBar(title: viewModel.title)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.models.indices, id: \.self) { index in
                    let model = viewModel.models[index]
                    MessageImageItemView(model: model)
                        .onTapGesture {
                            let urls = viewModel.models.compactMap { $0.url }
                            viewModel.fullScreenCoverType = .openImageDetail(urls)
                        }
                }
            }
        }
    }
}

extension MessageImagesView {
    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<MessageImagesFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .openImageDetail(urls):
            NavigationView {
                ImageDetailView(
                    viewModel: ImageDetailViewModel(
                        imageUrls: urls,
                        delegate: viewModel
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .introspectNavigationController { navigationController in
                navigationController.configure(
                    backgroundColor: ColorAssets.neutralLight.color,
                    foregroundColor: ColorAssets.neutralDarkGrey.color
                )
                navigationController.view.backgroundColor = .clear
                navigationController.parent?.view.backgroundColor = .clear
            }
        }
    }
}
