//
//  MyCouponsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/06/2023.
//
//

import SwiftUI

// MARK: - MyCouponsView

struct MyCouponsView<ViewModel: MyCouponsViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.shopCoupon)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        ZStack {
            buildMainView()
                .statefull(
                    state: $viewModel.viewState,
                    isEmpty: { viewModel.myCoupons.isEmpty },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
            buildNavigationLinks()
        }
    }

    private func buildMainView() -> some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem.flexible(spacing: 12), count: 2)) {
                ForEach(viewModel.myCoupons.indices, id: \.self) {
                    let model = viewModel.myCoupons[$0]
                    MyCouponItemView(
                        model: model,
                        selectAction: {
                            viewModel.navigationType = .myCouponDetail(model)
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewModel.navigationType = .myCouponDetail(model)
                    }
                }
            }
            .padding(16)
            StatefullFooterView(
                state: $viewModel.footerState,
                errorView: EmptyView(),
                noMoreDataView: EmptyView()
            )
            .onAppear {
                viewModel.loadMoreAction.send()
            }
        }
        .background(ColorAssets.neutralLightGrey.swiftUIColor.ignoresSafeArea())
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

extension MyCouponsView {
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

extension MyCouponsView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<MyCouponsNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .myCouponDetail(myCoupon):
            CouponDetailView(
                viewModel: CouponDetailViewModel(
                    couponDetailInputType: .myCoupon(myCoupon)
                )
            )
        }
    }
}

// MARK: - MyCouponsView_Previews

struct MyCouponsView_Previews: PreviewProvider {
    static var previews: some View {
        MyCouponsView(viewModel: MyCouponsViewModel())
    }
}
