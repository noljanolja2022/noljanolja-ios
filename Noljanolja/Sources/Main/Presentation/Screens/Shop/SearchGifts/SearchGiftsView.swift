//
//  SearchGiftsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//
//

import Combine
import SwiftUI

// MARK: - SearchGiftsUIViews

final class SearchGiftsUIViews: NSObject {
    // MARK: Dependencies

    private let viewModel: SearchGiftsViewModel

    init(viewModel: SearchGiftsViewModel) {
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

extension SearchGiftsUIViews: UITextFieldDelegate {
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

// MARK: - SearchGiftsView

struct SearchGiftsView<ViewModel: SearchGiftsViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    private let uiViews: SearchGiftsUIViews

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.uiViews = SearchGiftsUIViews(viewModel: viewModel)
    }

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
            .navigationBarTitle("", displayMode: .inline)
            .hideNavigationBar()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
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
                SearchView(placeholder: L10n.shopSearchProducts, text: $viewModel.searchText)
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
                    viewModel.clearGiftKeywordsAction.send()
                },
                label: {
                    Text(L10n.shopClearAll)
                        .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
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
                        KeywordItemView(
                            model: KeywordItemViewModel(keyword: model.keyword),
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
                buildStatefullGiftsView()
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
            LazyVGrid(columns: Array(repeating: GridItem.flexible(spacing: 12), count: 2)) {
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

extension SearchGiftsView {
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

extension SearchGiftsView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<SearchGiftsNavigationType>
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

// MARK: - SearchGiftsView_Previews

struct SearchGiftsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchGiftsView(viewModel: SearchGiftsViewModel())
    }
}
