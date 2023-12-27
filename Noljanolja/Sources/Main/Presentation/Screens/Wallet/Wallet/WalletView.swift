//
//  WalletView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - WalletView

struct WalletView<ViewModel: WalletViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @State private var selectedMoneyType = MoneyType.point

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
                isEmpty: { viewModel.model == nil },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        if let model = viewModel.model {
            VStack(spacing: 12) {
                buildUserInfoView(model)
                buildScrollView(model)
            }
        }
    }

    private func buildUserInfoView(_ model: WalletModel) -> some View {
        WalletUserInfoView(
            model: model.userInfo,
            tierAction: {
                viewModel.navigationType = .myRanking
            },
            settingAction: {
                viewModel.navigationType = .setting
            }
        )
    }

    private func buildScrollView(_ model: WalletModel) -> some View {
        ScrollView {
            buildCoinsView(model)

            VStack(spacing: 15) {
                buildPointsView(model)
                buildActionView()
                buildExchangeView()
                buildCheckinProgressView(model)

                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }

    private func buildActionView() -> some View {
        Button {
            viewModel.navigationType = .transactionHistory
        } label: {
            Label(
                L10n.transactionHistory.uppercased(),
                icon: { ImageAssets.icHistory.swiftUIImage }
            )
        }
        .buttonStyle(PrimaryButtonStyle())
        .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
    }

    private func buildCoinsView(_ model: WalletModel) -> some View {
        ZStack {
            WalletMoneyView(
                model: WalletMoneyViewDataModel(
                    title: L10n.walletMyPoints,
                    titleColorName: ColorAssets.neutralRawLight.name,
                    changeString: nil,
                    changeColorName: ColorAssets.secondaryYellow200.name,
                    iconName: ImageAssets.icPoint.name,
                    valueString: model.point.formatted(),
                    valueColorName: ColorAssets.secondaryYellow400.name,
                    backgroundImageName: ImageAssets.bnPoint.name,
                    padding: 16
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, selectedMoneyType == .point ? 0 : 12)
            .offset(y: selectedMoneyType == .point ? 16 : 0)
            .aspectRatio(2, contentMode: .fill)
            .zIndex(selectedMoneyType == .point ? 1 : 0)

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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, selectedMoneyType == .coin ? 0 : 12)
            .offset(y: selectedMoneyType == .coin ? 16 : 0)
            .aspectRatio(2, contentMode: .fill)
            .zIndex(selectedMoneyType == .coin ? 1 : 0)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 22)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedMoneyType = selectedMoneyType == .point ? .coin : .point
            }
        }
    }

    private func buildExchangeView() -> some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                Text(L10n.transactionConvertPointsToCash)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                HStack {
                    Spacer()
                    ImageAssets.icQuestion.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 6)
                }
            }

            HStack(alignment: .center, spacing: 27) {
                ImageAssets.icPoint.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                ImageAssets.icBack.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .rotationEffect(.degrees(180))

                ImageAssets.icCoin.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            Button(L10n.transactionConvertNow.uppercased(), action: {
                viewModel.navigationType = .exchange
            })
            .buttonStyle(PrimaryButtonStyle(
                enabledBackgroundColor: ColorAssets.secondaryYellow400.swiftUIColor)
            )
            .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
            .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
        }
        .padding(14)
        .background(ColorAssets.secondaryYellow50.swiftUIColor)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(ColorAssets.secondaryYellow400.swiftUIColor, lineWidth: 1.5)
        )
    }

    private func buildPointsView(_ model: WalletModel) -> some View {
        HStack(spacing: 12) {
            WalletPointView(
                model: WalletPointViewDataModel(
                    title: L10n.walletAccumulatedPoint,
                    titleColorName: ColorAssets.neutralDarkGrey.name,
                    point: model.accumulatedPointsToday,
                    pointColorName: ColorAssets.secondaryYellow300.name,
                    unitColorName: ColorAssets.neutralDarkGrey.name,
                    actionTitle: L10n.walletViewHistory,
                    type: "P"
                )
            )

            WalletPointView(
                model: WalletPointViewDataModel(
                    title: L10n.walletCashThatCanBeUsed,
                    titleColorName: ColorAssets.neutralDarkGrey.name,
                    point: model.coin.int,
                    pointColorName: ColorAssets.systemBlue.name,
                    unitColorName: ColorAssets.neutralDarkGrey.name,
                    actionTitle: L10n.walletExchangeMoney,
                    type: "C"
                ),
                action: {
                    viewModel.goShopAction.send()
                }
            )
        }
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.3),
            radius: 11,
            x: 4,
            y: 4
        )
    }

    private func buildCheckinProgressView(_ model: WalletModel) -> some View {
        VStack(spacing: 24) {
            CheckinOverviewView()

            HStack(spacing: 24) {
                CheckinProgressSumaryView(
                    completedCount: model.checkinProgresses.filter { $0.isCompleted }.count,
                    count: model.checkinProgresses.count,
                    forcegroundColor: ColorAssets.neutralDarkGrey.swiftUIColor,
                    secondaryForcegroundColor: ColorAssets.neutralDeepGrey.swiftUIColor
                )

                Button(
                    action: {
                        viewModel.navigationType = .checkin
                    },
                    label: {
                        Text(L10n.walletAttendNow)
                            .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                            .height(32)
                            .padding(.horizontal, 24)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                            .background(ColorAssets.secondaryYellow300.swiftUIColor)
                            .cornerRadius(4)
                    }
                )
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(8)
        .visible(.gone)
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

extension WalletView {
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

extension WalletView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<WalletNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .myRanking:
            MyRankingView(
                viewModel: MyRankingViewModel()
            )
        case .setting:
            ProfileSettingView(
                viewModel: ProfileSettingViewModel(
                    delegate: viewModel
                )
            )
        case .transactionHistory:
            TransactionHistoryView(
                viewModel: TransactionHistoryViewModel()
            )
        case .checkin:
            CheckinView(
                viewModel: CheckinViewModel()
            )
        case .exchange:
            ExchangeView(
                viewModel: ExchangeViewModel()
            )
        }
    }
}

// MARK: - WalletView_Previews

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView(
            viewModel: WalletViewModel()
        )
    }
}
