//
//  TransactionDashboardView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//
//

import Charts
import SwiftUI
import SwiftUIX

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
        .background(ColorAssets.neutralLightGrey.swiftUIColor.ignoresSafeArea())
    }

    @ViewBuilder
    private func buildBarChartView() -> some View {
        if let model = viewModel.model {
            VStack(alignment: .trailing, spacing: 12) {
                Text(model.title)
                    .font(.system(size: 14))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .center)

                BarChartSwiftUIView(
                    data: model.chartModel.data,
                    config: {
                        let config = BarChartConfig()
                        config.isScaleEnabled = false
                        return config
                    }(),
                    legend: {
                        let legend = LegendConfig()
                        legend.enabled = false
                        return legend
                    }(),
                    xAxis: model.chartModel.xAxis,
                    leftAxis: {
                        let leftAxis = YAxisConfig()
                        leftAxis.drawBottomYLabelEntryEnabled = true
                        leftAxis.labelFont = .systemFont(ofSize: 6, weight: .medium)
                        leftAxis.drawGridLinesEnabled = false
                        leftAxis.valueFormatter = LargeValueFormatter()
                        leftAxis.axisMinimum = 0
                        return leftAxis
                    }(),
                    rightAxis: {
                        let rightAxis = YAxisConfig()
                        rightAxis.drawGridLinesEnabled = false
                        rightAxis.drawAxisLineEnabled = false
                        rightAxis.drawLabelsEnabled = false
                        rightAxis.axisMinimum = 0
                        return rightAxis
                    }()
                )
                .aspectRatio(2, contentMode: .fit)
                .background(ColorAssets.neutralLight.swiftUIColor)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(model.chartModel.data.dataSets.indices, id: \.self) { index in
                        let dataSet = model.chartModel.data.dataSets[index]
                        HStack(spacing: 4) {
                            Spacer()
                                .frame(width: 16, height: 16)
                                .background(Color(dataSet.colors[0]))
                                .cornerRadius(4)
                            Text(dataSet.label ?? "")
                                .font(.system(size: 6, weight: .medium))
                                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                                .alignmentGuide(.leading, computeValue: { $0[.leading] })
                                .alignmentGuide(.top, computeValue: { $0[.top] })
                                .alignmentGuide(.trailing, computeValue: { $0[.trailing] })
                                .alignmentGuide(.bottom, computeValue: { $0[.bottom] })
                        }
                    }
                }
                .padding(.trailing, 16)
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
}

extension TransactionDashboardView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
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
