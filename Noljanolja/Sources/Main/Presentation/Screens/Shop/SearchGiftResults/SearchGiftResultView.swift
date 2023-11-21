//
//  SearchGiftResultView.swift
//  Noljanolja
//
//  Created by kii on 21/11/2023.
//

import SwiftUI

// MARK: - SearchGiftResultsView

struct SearchGiftResultsView<ViewModel: SearchGiftResultsViewModel>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .hideNavigationBar()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 16) {
            buildSearchView()
            buildSummaryView()
            buildStatefullGiftsView()
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    private func buildSearchView() -> some View {
        VStack(spacing: 8) {
            Text(L10n.shopWelcomeNoljaShop)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: ImageAssets.icBack.swiftUIImage
                        .frame(width: 36, height: 36)
                )
                SearchView(placeholder: L10n.shopSearchProducts, text: .constant(viewModel.searchText))
                    .frame(maxWidth: .infinity)
                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    .cornerRadius(8)
                    .disabled(true)
            }
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func buildSummaryView() -> some View {
        HStack(spacing: 12) {
            SummaryItemView(
                title: L10n.walletMyCash,
                titleColorName: ColorAssets.secondaryYellow400.name,
                imageName: ImageAssets.icCoin.name,
                value: viewModel.model?.coinModel?.balance.formatted() ?? "---"
            )
            SummaryItemView(
                title: "Voucher Wallet",
                titleColorName: ColorAssets.primaryGreen200.name,
                imageName: ImageAssets.icWallet2.name,
                value: (viewModel.model?.coinModel?.giftCount).flatMap { String($0) } ?? "---"
            )
        }
        .padding(.horizontal, 16)
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    @ViewBuilder
    private func buildStatefullGiftsView() -> some View {
        buildGiftsView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.model?.isEmpty ?? true },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildGiftsView() -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                let models = viewModel.model?.giftsResponse.data ?? []
                ForEach(models.indices, id: \.self) {
                    let model = models[$0]
                    ShopGiftItemView(model: model)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.navigationType = .giftDetail(model)
                        }
                }
            }
            .padding(.horizontal, 16)

            StatefullFooterView(
                state: $viewModel.footerState,
                errorView: EmptyView(),
                noMoreDataView: EmptyView()
            )
            .onAppear {
                viewModel.loadMoreAction.send()
            }
        }
        .padding(.bottom, 16)
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

extension SearchGiftResultsView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.primaryGreen200.swiftUIColor)
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

extension SearchGiftResultsView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<SearchGiftResultsNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .giftDetail(gift):
            GiftDetailView(
                viewModel: GiftDetailViewModel(
                    giftDetailInputType: .gift(gift)
                )
            )
        }
    }
}
