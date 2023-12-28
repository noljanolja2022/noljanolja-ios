//
//  ShopGiftCollectionView.swift
//  Noljanolja
//
//  Created by Duy Dinh on 21/11/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - ShopGiftCollectionView

struct ShopGiftCollectionView: View {
    // MARK: Dependencies

    @StateObject var viewModel: ShopGiftCollectionViewModel
    @EnvironmentObject var themeManager: AppThemeManager

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        buildMainView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.title)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                ImageAssets.icArrowRight.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            ZStack {
                buildNavigationLink()
                buildContentStatefullView()
            }
        }
        .background(viewModel.type == .topFeatures
            ? themeManager.theme.primary200
            : ColorAssets.neutralLight.swiftUIColor)
        .visible(!viewModel.models.isEmpty)
    }

    @ViewBuilder
    private func buildContentStatefullView() -> some View {
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
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.models.indices, id: \.self) {
                    let model = viewModel.models[$0]
                    ShopGiftCollectionItemView(model: model)
                        .onTapGesture {
                            viewModel.navigationType = .giftDetail(model)
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 5)
    }
}

extension ShopGiftCollectionView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        EmptyView()
    }

    private func buildErrorView() -> some View {
        EmptyView()
    }
}

extension ShopGiftCollectionView {
    @ViewBuilder
    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { buildNavigationLinkDestinationView($0) },
            label: {}
        )
    }

    @ViewBuilder
    private func buildNavigationLinkDestinationView(_ type: Binding<ShopGiftNavigationType>) -> some View {
        switch type.wrappedValue {
        case let .giftDetail(gift):
            GiftDetailView(
                viewModel: GiftDetailViewModel(
                    giftDetailInputType: .gift(gift)
                )
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(_: Binding<ShopGiftFullScreenCoverType>) -> some View {}
}
