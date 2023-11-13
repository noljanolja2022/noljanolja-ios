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
            buildPointView()
            buildTabView()
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
            Text("Exchange The Best\nProduct With Cash")
                .dynamicFont(.systemFont(ofSize: 32, weight: .medium))
                .multilineTextAlignment(.leading)
                .foregroundColor(ColorAssets.secondaryYellow400.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
    private func buildPointView() -> some View {
        if let coinModel = viewModel.model.coinModel {
            WalletMoneyView(
                model: WalletMoneyViewDataModel(
                    title: L10n.walletMyCash,
                    titleColorName: ColorAssets.neutralRawDarkGrey.name,
                    changeString: nil,
                    changeColorName: ColorAssets.neutralRawLight.name,
                    iconName: ImageAssets.icCoin.name,
                    valueString: coinModel.balance.formatted(),
                    valueColorName: ColorAssets.neutralRawDarkGrey.name,
                    backgroundImageName: ImageAssets.bnCash.name,
                    padding: 16
                )
            )
            .frame(height: 120)
            .padding(.horizontal, 16)
            .shadow(
                color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )
        }
    }
    
    private func buildTabView() -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                ForEach(ShopHomeTabContentType.allCases.indices, id: \.self) { index in
                    let tabContentType = ShopHomeTabContentType.allCases[index]
                    VStack(spacing: 0) {
                        Text(tabContentType.title)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .dynamicFont(
                                .systemFont(
                                    ofSize: 16,
                                    weight: viewModel.tabContentType == tabContentType ? .bold : .regular
                                )
                            )
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        Spacer()
                            .frame(maxWidth: .infinity)
                            .frame(height: 4)
                            .background(
                                viewModel.tabContentType == tabContentType ? ColorAssets.primaryGreen200.swiftUIColor : .clear
                            )
                            .cornerRadius(2)
                    }
                    .frame(height: 44)
                    .onTapGesture {
                        viewModel.tabContentType = tabContentType
                    }
                }
            }
            .padding(.horizontal, 16)
            
            switch viewModel.tabContentType {
            case .shopGift:
                ShopGiftView(viewModel: ShopGiftViewModel())
            case .myGift:
                MyGiftView(viewModel: MyGiftViewModel())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
