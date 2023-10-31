import GoogleMobileAds
import SwiftUI
import SwiftUIX

// MARK: - ExchangeView

struct ExchangeView: View {
    // MARK: Dependencies

    @StateObject var viewModel: ExchangeViewModel

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        buildMainView()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.exchangeCashTitle)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) {
                Alert($0) { _ in }
            }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        ZStack {
            buildNavigationLink()
            buildContentView()
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.model == nil },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        ScrollView {
            buildScrollContentView()
        }
    }
    
    @ViewBuilder
    private func buildScrollContentView() -> some View {
        if let model = viewModel.model {
            VStack(spacing: 20) {
                buildCoinsView(model)
                buildCashBoxView()
                buildExchangeView()
            }
            .padding(16)
            .shadow(
                color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )
        }
    }
    
    @ViewBuilder
    private func buildCoinsView(_ model: ExchangeViewDataModel) -> some View {
        VStack(spacing: 16) {
            WalletMoneyView(
                model: WalletMoneyViewDataModel(
                    title: L10n.walletMyPoint,
                    titleColorName: ColorAssets.primaryGreen50.name,
                    changeString: nil,
                    changeColorName: ColorAssets.secondaryYellow200.name,
                    iconName: ImageAssets.icPoint.name,
                    valueString: model.point.formatted(),
                    valueColorName: ColorAssets.secondaryYellow400.name,
                    backgroundImageName: ImageAssets.bnPoint.name,
                    padding: 16
                )
            )
            .aspectRatio(2, contentMode: .fill)
            
            HStack(spacing: 12) {
                ImageAssets.icExchange.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(L10n.exchangeDesciption)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
            }
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            
            WalletMoneyView(
                model: WalletMoneyViewDataModel(
                    title: L10n.walletMyCash,
                    titleColorName: ColorAssets.neutralRawDarkGrey.name,
                    changeString: nil,
                    changeColorName: ColorAssets.neutralRawLight.name,
                    iconName: ImageAssets.icCoin.name,
                    valueString: model.coin.formatted(),
                    valueColorName: ColorAssets.neutralRawDarkGrey.name,
                    backgroundImageName: ImageAssets.bnCash.name,
                    padding: 16
                )
            )
        }
    }
    
    private func buildCashBoxView() -> some View {
        HStack(alignment: .center, spacing: 4) {
            ImageAssets.icGift.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Text("Cash Box")
                .dynamicFont(.systemFont(ofSize: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
            Text("750 Open box")
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .foregroundColor(ColorAssets.systemBlue.swiftUIColor)
        }
        .padding(12)
        .background(ColorAssets.secondaryYellow50.swiftUIColor)
        .cornerRadius(16)
    }
    
    private func buildExchangeView() -> some View {
        Button(
            L10n.exchangeTitle.uppercased(),
            action: {
                viewModel.exchangeAction.send()
            }
        )
        .disabled((viewModel.model?.exchangeRate ?? 0) <= 0)
        .buttonStyle(
            PrimaryButtonStyle(
                isEnabled: (viewModel.model?.exchangeRate ?? 0) > 0
            )
        )
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
    }
}

extension ExchangeView {
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

extension ExchangeView {
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
    private func buildNavigationLinkDestinationView(_: Binding<ExchangeNavigationType>) -> some View {}

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(_: Binding<ExchangeFullScreenCoverType>) -> some View {}
}

#Preview {
    ExchangeView(
        viewModel: ExchangeViewModel()
    )
}
