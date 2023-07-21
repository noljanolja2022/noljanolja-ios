//
//  TransactionDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//
//

import SwiftUI

// MARK: - TransactionDetailView

struct TransactionDetailView<ViewModel: TransactionDetailViewModel>: View {
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
                    Text(L10n.transactionDetail)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        buildContentView()
    }

    private func buildContentView() -> some View {
        VStack(spacing: 16) {
            buildPointsView()
            buildDetailView()
        }
        .padding(16)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(12)
        .padding(16)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
    }

    private func buildPointsView() -> some View {
        VStack(spacing: 8) {
            Text(viewModel.model.type)
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            Text(viewModel.model.point)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(viewModel.model.pointColor))
        }
    }

    private func buildDetailView() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text(L10n.transactionDetailStatus)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text("Complete")
                    .font(.system(size: 14))
                    .frame(height: 24)
                    .padding(.horizontal, 12)
                    .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                    .background(ColorAssets.primaryGreen200.swiftUIColor)
                    .cornerRadius(12)
            }

            HStack(spacing: 8) {
                Text(L10n.transactionDetailTime)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text(viewModel.model.dateTime)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }

            HStack(spacing: 8) {
                Text(L10n.transactionDetailCode)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text(viewModel.model.code)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }
    }
}
