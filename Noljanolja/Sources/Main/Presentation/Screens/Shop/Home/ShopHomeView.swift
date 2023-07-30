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
        buildContentView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        ZStack {
            buildMainView()
                .statefull(
                    state: $viewModel.viewState,
                    isEmpty: { viewModel.model.isEmpty },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
            buildNavigationLinks()
        }
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        VStack(spacing: 4) {
            buildSearchView()
            buildScrollView()
        }
        .background(ColorAssets.primaryGreen200.swiftUIColor)
    }

    private func buildScrollView() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                buildMyPointView()
                buildMyCouponsView()
                buildShopCouponsView()
            }
            .padding(.vertical, 16)
        }
    }

    private func buildSearchView() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("Welcome to Nolja shop!")
                    .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ImageAssets.icQuestion.swiftUIImage
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            SearchView(placeholder: "Search product", text: .constant(""))
                .frame(maxWidth: .infinity)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius([.bottomLeading, .bottomTrailing], 12)
        .disabled(true)
        .onTapGesture {
            viewModel.navigationType = .search
        }
    }

    @ViewBuilder
    private func buildMyPointView() -> some View {
        if let memberInfo = viewModel.model.memberInfo {
            WalletMyPointView(point: memberInfo.point)
                .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func buildMyCouponsView() -> some View {
        if !viewModel.model.myCoupons.isEmpty {
            MyCouponView(
                model: viewModel.model.myCoupons,
                viewAllAction: {
                    viewModel.navigationType = .myCoupons
                },
                selectAction: {
                    viewModel.navigationType = .myCouponDetail($0)
                }
            )
        }
    }

    @ViewBuilder
    private func buildShopCouponsView() -> some View {
        if !viewModel.model.shopCoupons.isEmpty {
            ShopCouponView(
                model: viewModel.model.shopCoupons,
                selectAction: {
                    viewModel.navigationType = .couponDetail($0)
                }
            )
            .padding(.horizontal, 16)
        }
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
            SearchCouponsView(
                viewModel: SearchCouponsViewModel()
            )
        case .myCoupons:
            MyCouponsView(
                viewModel: MyCouponsViewModel()
            )
        case let .couponDetail(coupon):
            CouponDetailView(
                viewModel: CouponDetailViewModel(
                    couponDetailInputType: .coupon(coupon)
                )
            )
        case let .myCouponDetail(myCoupon):
            CouponDetailView(
                viewModel: CouponDetailViewModel(
                    couponDetailInputType: .myCoupon(myCoupon)
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
