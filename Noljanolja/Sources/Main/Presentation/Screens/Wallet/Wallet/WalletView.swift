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

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        ZStack {
            buildContentView()
                .statefull(
                    state: $viewModel.viewState,
                    isEmpty: { viewModel.model == nil },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )

            buildNavigationLinks()
        }
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        if let model = viewModel.model {
            VStack(spacing: 12) {
                buildUserInfoView(model)
                buildScrollView(model)
            }
            .background(ColorAssets.primaryGreen200.swiftUIColor)
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
            VStack(spacing: 12) {
                buildPointsView(model)
                buildCheckinProgressView(model)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .shadow(
                color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )
        }
    }

    private func buildPointsView(_ model: WalletModel) -> some View {
        VStack(spacing: 12) {
            WalletMyPointView(point: model.point)

            HStack(spacing: 12) {
                WalletPointView(
                    model: WalletPointModel(
                        title: L10n.walletAccumulatedPoint,
                        point: model.accumulatedPointsToday,
                        actionTitle: L10n.walletViewHistory
                    ),
                    pointColor: ColorAssets.neutralDarkGrey.swiftUIColor,
                    action: {
                        viewModel.navigationType = .transactionHistory
                    }
                )

                WalletPointView(
                    model: WalletPointModel(
                        title: L10n.walletPointCanExchange,
                        point: model.exchangeablePoints,
                        actionTitle: L10n.walletExchangeMoney
                    ),
                    pointColor: ColorAssets.systemBlue.swiftUIColor
                )
            }
        }
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
