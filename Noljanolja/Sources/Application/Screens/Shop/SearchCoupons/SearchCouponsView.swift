//
//  SearchCouponsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//  
//

import SwiftUI

// MARK: SearchCouponsView

struct SearchCouponsView<ViewModel: SearchCouponsViewModel>: View {
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

    private func buildContentView() -> some View {
        ZStack {
            buildMainView()
                .statefull(
                    state: $viewModel.viewState,
                    isEmpty: { viewModel.coupons.isEmpty },
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

    private func buildSearchView() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("Welcome to Nolja shop!")
                    .font(.system(size: 14, weight: .medium))
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
    }

    private func buildScrollView() -> some View {
        ScrollView {

        }
    }

    private func buildKeywordsView() -> some View {
        
    }
}

extension SearchCouponsView {
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
}

extension SearchCouponsView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<SearchCouponsNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .couponDetail(coupon):
            CouponDetailView(
                viewModel: CouponDetailViewModel(
                    couponDetailInputType: .coupon(coupon)
                )
            )
        }
    }
}

struct SearchCouponsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCouponsView(viewModel: SearchCouponsViewModel())
    }
}
