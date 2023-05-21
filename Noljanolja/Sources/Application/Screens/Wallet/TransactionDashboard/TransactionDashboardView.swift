//
//  TransactionDashboardView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//
//

import SwiftUI

// MARK: - TransactionDashboardView

struct TransactionDashboardView<ViewModel: TransactionDashboardViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dashboard")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.model?.sections.isEmpty ?? true },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 16) {
            buildBarChartView()
            buildListView()
        }
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
    }

    @ViewBuilder
    private func buildBarChartView() -> some View {
        if let model = viewModel.model {
            VStack(spacing: 8) {
                Text(model.title)
                    .font(.system(size: 14))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .center)

                BarChartSwiftUIView(
                    data: model.barChartData
                )
                .aspectRatio(2, contentMode: .fit)
                .background(ColorAssets.neutralLight.swiftUIColor)
            }
            .padding(16)
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius(12)
            .padding(16)
        }
    }

    private func buildListView() -> some View {
        VStack(spacing: 16) {
            Text("Recent transactions")
                .font(.system(size: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)

            ScrollView {
                LazyVStack(spacing: 12) {
                    if let sections = viewModel.model?.sections {
                        ForEach(sections.indices, id: \.self) { index in
                            buildSectionView(sections[index])
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func buildSectionView(_ section: TransactionDashboardSectionModel) -> some View {
        VStack(spacing: 0) {
            TransactionDashboardHeaderView(model: section.header)

            ForEach(section.items.indices, id: \.self) { index in
                buildItemView(section.items[index])
            }
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func buildItemView(_ item: TransactionDashboardItemModel) -> some View {
        TransactionDashboardItemView(model: item)
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
}
