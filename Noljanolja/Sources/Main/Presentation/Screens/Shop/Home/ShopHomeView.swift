//
//  ShopHomeView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//
//

import SwiftUI

// MARK: - ShopHomeView

struct ShopHomeView<ViewModel: ShopHomeViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @EnvironmentObject var themeManager: AppThemeManager

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        VideoDetailRootContainerView(
            content: {
                ZStack {
                    buildContentStatefullView()
                    buildNavigationLinks()
                }
            },
            viewModel: VideoDetailRootContainerViewModel()
        )
    }

    private func buildContentStatefullView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.model.isEmpty },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()

            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        buildSummaryView()
                        buildCategoriesView()
                    }
                    .padding(.vertical, 16)
                    .background(
                        themeManager.theme == .yellow
                            ? themeManager.theme.primary400
                            : ColorAssets.neutralLight.swiftUIColor
                    )
                    buildBrandsView()
                    buildTopFeaturesView()
                    buildTodayOffersView()
                    buildRecommendView()
                    buildForYouView()
                }
            }
        }
        .background(Color.white)
    }

    private func buildHeaderView() -> some View {
        HStack(spacing: 12) {
            HStack {
                Text(L10n.shopSearchProducts)
                    .dynamicFont(.systemFont(ofSize: 14))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Spacer()
                ImageAssets.icSearch.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .height(24)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .height(36)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(5)
            .onTapGesture {
                viewModel.navigationType = .search
            }

            AvatarView(url: viewModel.avatarURL, size: .init(width: 24, height: 24))
                .onTapGesture {
                    viewModel.navigationType = .setting
                }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .background(themeManager.theme.primary200)
        .cornerRadius([.bottomTrailing, .bottomLeading], 13)
    }

    @ViewBuilder
    private func buildCategoriesView() -> some View {
        CategoriesView(
            viewModel: CategoriesViewModel()) { category in
                viewModel.navigationType = .listGiftCategory(category)
            }
    }

    @ViewBuilder
    private func buildSummaryView() -> some View {
        HStack(spacing: 12) {
            SummaryItemView(
                title: L10n.walletMyCash,
                titleColorName: ColorAssets.secondaryYellow400.name,
                imageName: ImageAssets.icCoin.name,
                value: viewModel.model.coinModel?.balance.formatted() ?? "---"
            )
            SummaryItemView(
                title: L10n.voucherWallet,
                titleColorName: ColorAssets.primaryGreen200.name,
                imageName: ImageAssets.icWallet2.name,
                value: (viewModel.model.coinModel?.giftCount).flatMap { String($0) } ?? "---"
            )
            .onTapGesture {
                viewModel.navigationType = .myGifts
            }
        }
        .padding(.horizontal, 16)
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    private func buildTopFeaturesView() -> some View {
        ShopGiftCollectionView(viewModel: ShopGiftCollectionViewModel(type: .topFeatures))
    }

    private func buildTodayOffersView() -> some View {
        ShopGiftCollectionView(viewModel: ShopGiftCollectionViewModel(type: .todayOffers))
    }

    private func buildRecommendView() -> some View {
        ShopGiftCollectionView(viewModel: ShopGiftCollectionViewModel(type: .recommend))
    }

    private func buildForYouView() -> some View {
        ShopGiftView(viewModel: ShopGiftViewModel(title: L10n.shopForYou))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildBrandsView() -> some View {
        ShopBrandsView(viewModel: ShopBrandsViewModel())
    }
}

extension ShopHomeView {
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

extension ShopHomeView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<ShopHomeNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .search:
            SearchGiftsView(
                viewModel: SearchGiftsViewModel()
            )
        case .myGifts:
            MyGiftsView(
                viewModel: MyGiftsViewModel()
            )
        case let .giftDetail(gift):
            GiftDetailView(
                viewModel: GiftDetailViewModel(
                    giftDetailInputType: .gift(gift)
                )
            )
        case let .myGiftDetail(myGift):
            GiftDetailView(
                viewModel: GiftDetailViewModel(
                    giftDetailInputType: .myGift(myGift)
                )
            )
        case let .listGiftCategory(category):
            ListGiftCategoryView(
                viewModel: ListGiftCategoryViewModel(
                    category: category
                )
            )
        case .setting:
            ProfileSettingView(
                viewModel: ProfileSettingViewModel(
                    delegate: viewModel
                )
            )
        }
    }
}

// MARK: - ShopHomeView_Previews

struct ShopHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ShopHomeView(viewModel: ShopHomeViewModel())
    }
}
