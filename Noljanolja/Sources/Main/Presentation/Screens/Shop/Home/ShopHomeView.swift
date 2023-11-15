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
        VStack(spacing: 8) {
            buildHeaderView()
            buildSummaryView()
            buildShopGiftView()
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
    }
    
    private func buildHeaderView() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Text(L10n.shopWelcomeNoljaShop)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ImageAssets.icQuestion.swiftUIImage
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            
            SearchView(placeholder: L10n.shopSearchProducts, text: .constant(""))
                .frame(maxWidth: .infinity)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .disabled(true)
        .onTapGesture {
            viewModel.navigationType = .search
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
                title: "Voucher Wallet",
                titleColorName: ColorAssets.primaryGreen200.name,
                imageName: ImageAssets.icWallet2.name,
                value: viewModel.model.myGiftString ?? "---"
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
    
    private func buildShopGiftView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text("For you")
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                ImageAssets.icArrowRight.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            ShopGiftView(viewModel: ShopGiftViewModel())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.top, 16)
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
        }
    }
}

// MARK: - ShopHomeView_Previews

struct ShopHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ShopHomeView(viewModel: ShopHomeViewModel())
    }
}
