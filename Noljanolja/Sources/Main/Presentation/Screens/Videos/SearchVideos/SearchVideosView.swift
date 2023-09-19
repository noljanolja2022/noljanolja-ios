//
//  SearchVideosView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/07/2023.
//
//

import Combine
import SwiftUI

// MARK: - SearchVideosUIViews

final class SearchVideosUIViews: NSObject {
    // MARK: Dependencies

    private let viewModel: SearchVideosViewModel

    init(viewModel: SearchVideosViewModel) {
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

extension SearchVideosUIViews: UITextFieldDelegate {
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

// MARK: - SearchVideosView

struct SearchVideosView<ViewModel: SearchVideosViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    private let uiViews: SearchVideosUIViews

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.uiViews = SearchVideosUIViews(viewModel: viewModel)
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
                    ColorAssets.neutralLight.swiftUIColor
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
            HStack(spacing: 0) {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: ImageAssets.icBack.swiftUIImage
                        .frame(width: 36, height: 36)
                )
                SearchView(placeholder: "Search video", text: $viewModel.searchText)
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
                    viewModel.clearKeywordsAction.send()
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
                buildStatefullResultView()
            }
        }
    }

    private func buildStatefullResultView() -> some View {
        buildResultView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.model?.data.isEmpty ?? true },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildResultView() -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                let models = viewModel.model?.data ?? []
                ForEach(models.indices, id: \.self) {
                    let model = models[$0]
                    let itemViewmodel = CommonVideoItemViewModel(model)
                    CommonVideoItemView(
                        model: itemViewmodel,
                        elementTypes: [.actionButton, .category, .description]
                    )
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        VideoDetailViewModel.shared.show(videoId: model.id)
                    }
                }
            }

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

extension SearchVideosView {
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

extension SearchVideosView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _: Binding<SearchVideosNavigationType>
    ) -> some View {}
}
