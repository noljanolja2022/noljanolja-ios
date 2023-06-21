//
//  SearchCouponsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//
//

import Combine
import SwiftUI

// MARK: - SearchCouponsUIViews

final class SearchCouponsUIViews: NSObject {
    // MARK: Dependencies

    private let viewModel: SearchCouponsViewModel

    init(viewModel: SearchCouponsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: Views

    fileprivate var textField: UITextField? {
        didSet {
            textField?.delegate = self
        }
    }
}

// MARK: UITextFieldDelegate

extension SearchCouponsUIViews: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        viewModel.isKeywordHidden = false
    }

    func textFieldDidEndEditing(_: UITextField) {
        viewModel.isKeywordHidden = true
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        viewModel.searchAction.send()
        return true
    }
}

// MARK: - SearchCouponsView

struct SearchCouponsView<ViewModel: SearchCouponsViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    private let uiViews: SearchCouponsUIViews

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.uiViews = SearchCouponsUIViews(viewModel: viewModel)
    }

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var progressHUBState: ProgressHUBState

    var body: some View {
        buildBodyView()
            .navigationBarTitle("", displayMode: .inline)
            .hideNavigationBar()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .background(
            ColorAssets.primaryGreen100.swiftUIColor
                .ignoresSafeArea()
                .overlay {
                    let color = viewModel.isKeywordHidden
                        ? ColorAssets.primaryGreen200.swiftUIColor
                        : ColorAssets.neutralLight.swiftUIColor
                    color
                        .ignoresSafeArea(edges: .bottom)
                }
        )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 4) {
            buildSearchView()
            buildMainView()
        }
    }

    private func buildSearchView() -> some View {
        VStack(spacing: 8) {
            Text("Welcome to Nolja shop!")
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: ImageAssets.icBack.swiftUIImage
                        .frame(width: 36, height: 36)
                )
                SearchView(placeholder: "Search product", text: $viewModel.searchText)
                    .frame(maxWidth: .infinity)
                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    .cornerRadius(8)
                    .introspectTextField {
                        self.uiViews.textField = $0
                    }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(ColorAssets.primaryGreen100.swiftUIColor)
        .cornerRadius([.bottomLeading, .bottomTrailing], 12)
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        if viewModel.isKeywordHidden {
            buildScrollView()
        } else {
            buildKeywordsView()
        }
    }

    @ViewBuilder
    private func buildKeywordsView() -> some View {
        VStack(spacing: 0) {
            Button(
                action: {
                    viewModel.clearCouponKeywordsAction.send()
                },
                label: {
                    Text("Clear all")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorAssets.neutralDeeperGrey.swiftUIColor)
                        .padding(16)
                }
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
            .hidden(viewModel.keywords.isEmpty)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.keywords.indices, id: \.self) {
                        let model = viewModel.keywords[$0]
                        CouponKeywordItemView(
                            model: model,
                            removeAction: {
                                viewModel.removeKeywordAction.send(model)
                            }
                        )
                        .onTapGesture {
                            viewModel.searchText = model.keyword
                            viewModel.searchAction.send()
                            uiViews.textField?.resignFirstResponder()
                        }
                    }
                }
            }
        }
    }

    private func buildScrollView() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                buildMyPointView()
                buildStatefullCouponsView()
            }
            .padding(.vertical, 16)
        }
    }

    @ViewBuilder
    private func buildMyPointView() -> some View {
        if let memberInfo = viewModel.model?.memberInfo {
            WalletMyPointView(point: memberInfo.point)
                .padding(.horizontal, 16)
        }
    }

    private func buildStatefullCouponsView() -> some View {
        buildCouponsView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.model?.isEmpty ?? true },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildCouponsView() -> some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem.flexible(spacing: 12), count: 2)) {
                let coupons = viewModel.model?.couponsResponse.data ?? []
                ForEach(coupons.indices, id: \.self) {
                    let model = coupons[$0]
                    ShopCouponItemView(model: model)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.navigationType = .couponDetail(model)
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

// MARK: - SearchCouponsView_Previews

struct SearchCouponsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCouponsView(viewModel: SearchCouponsViewModel())
    }
}
