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
                buildDetailMemberInfoView(model)
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

    private func buildDetailMemberInfoView(_ model: WalletModel) -> some View {
        ScrollView {
            VStack(spacing: 12) {
                WalletMyPointView(point: model.point)
                    .shadow(color: .black.opacity(0.2), radius: 8, y: 4)

                HStack(spacing: 12) {
                    WalletPointView(
                        model: WalletPointModel(
                            title: "Accumulated\npoints for the day",
                            point: model.accumulatedPointsToday,
                            actionTitle: "View history"
                        ),
                        pointColor: ColorAssets.neutralDarkGrey.swiftUIColor,
                        action: {
                            viewModel.navigationType = .transactionHistory
                        }
                    )

                    WalletPointView(
                        model: WalletPointModel(
                            title: "Points that\ncan be exchanged",
                            point: model.exchangeablePoints,
                            actionTitle: "Exchange money"
                        ),
                        pointColor: ColorAssets.systemBlue.swiftUIColor
                    )
                }
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)

                WalletNotiView()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }

    private func buildLoadingView() -> some View {
        LoadingView()
    }

    private func buildEmptyView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
