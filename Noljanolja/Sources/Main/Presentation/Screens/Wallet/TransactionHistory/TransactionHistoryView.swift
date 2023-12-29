//
//  TransactionHistoryView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//
//

import SwiftUI

// MARK: - TransactionHistoryView

struct TransactionHistoryView<ViewModel: TransactionHistoryViewModel>: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode

    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBar(title: L10n.transactionHistory, backButtonTitle: "", presentationMode: presentationMode, trailing: {})
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .navigationBarColor(ColorAssets.primaryGreen200.swiftUIColor)
    }

    private func buildContentView() -> some View {
        VStack(spacing: 12) {
            buildSearchView()
            buildFilterView()
            buildListView()
        }
        .padding(.vertical, 16)
    }

    private func buildSearchView() -> some View {
        SearchView(
            placeholder: L10n.transactionHistorySearchHint,
            text: .constant("")
        )
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }

    private func buildFilterView() -> some View {
        TransactionHistoryFilterView(
            selectedType: $viewModel.selectedTransactionType,
            types: TransactionType.allCases
        )
        .frame(height: 36)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func buildListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if let sections = viewModel.model?.sections {
                    ForEach(sections.indices, id: \.self) { index in
                        buildSectionView(sections[index])
                    }
                    buildStatefullFooterView(sections)
                }
            }
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.model?.sections.isEmpty ?? false },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
    }

    @ViewBuilder
    private func buildSectionView(_ section: TransactionHistorySectionModel) -> some View {
        LazyVStack(spacing: 0) {
            TransactionHistoryHeaderView(model: section.header)
                .onTapGesture {
                    viewModel.navigationType = .dashboard(section.header.dateTime)
                }

            ForEach(section.items.indices, id: \.self) { index in
                let item = section.items[index]
                TransactionHistoryItemView(
                    model: item,
                    titleColor: {
                        if colorScheme == .light {
                            return ColorAssets.neutralRawDarkGrey.swiftUIColor
                        } else if index % 2 == 0 {
                            return ColorAssets.neutralRawDarkGrey.swiftUIColor
                        } else {
                            return ColorAssets.neutralRawLightGrey.swiftUIColor
                        }
                    }()
                )
                .background(
                    index % 2 == 0
                        ? ColorAssets.secondaryYellow50.swiftUIColor
                        : ColorAssets.neutralLight.swiftUIColor // TODO: TO enable tap item
                )
                .onTapGesture {
                    viewModel.transactionDetailAction.send(item.id)
                }
            }
        }
    }

    private func buildStatefullFooterView(_: [TransactionHistorySectionModel]) -> some View {
        StatefullFooterView(
            state: $viewModel.footerState,
            errorView: EmptyView(),
            noMoreDataView: EmptyView()
        )
        .onAppear {
            viewModel.loadMoreAction.send()
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

extension TransactionHistoryView {
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

extension TransactionHistoryView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<TransactionHistoryNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .transactionDetail(transaction):
            TransactionDetailView(
                viewModel: TransactionDetailViewModel(
                    id: transaction.id,
                    reason: transaction.reason ?? ""
                )
            )
        case let .dashboard(date):
            TransactionDashboardView(
                viewModel: TransactionDashboardViewModel(
                    monthYearDate: date
                )
            )
        }
    }
}

// MARK: - TransactionHistoryView_Previews

struct TransactionHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionHistoryView(viewModel: TransactionHistoryViewModel())
    }
}
