//
//  ShopBrandsView.swift
//  Noljanolja
//
//  Created by Duy Đinh Văn on 29/11/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - ShopBrandsView

struct ShopBrandsView: View {
    // MARK: Dependencies

    @StateObject var viewModel: ShopBrandsViewModel

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
                Text(L10n.shopBrands)
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
        .background(ColorAssets.secondaryYellow300.swiftUIColor)
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
                    ShopBrandItemView(model: model)
                        .onTapGesture {
                            viewModel.navigationType = .listGiftCategory(model)
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 5)
    }
}

extension ShopBrandsView {
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

extension ShopBrandsView {
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
    private func buildNavigationLinkDestinationView(_ type: Binding<ShopBrandNavigationType>) -> some View {
        switch type.wrappedValue {
        case let .listGiftCategory(brand):
            ListGiftCategoryView(
                viewModel: ListGiftCategoryViewModel(
                    brand: brand
                )
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(_: Binding<ShopGiftFullScreenCoverType>) -> some View {}
}
