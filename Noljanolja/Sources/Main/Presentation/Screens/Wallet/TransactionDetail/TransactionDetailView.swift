//
//  TransactionDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//
//

import SwiftUI
import SwiftUINavigation

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
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
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
        ScrollView(.vertical) {
            VStack(spacing: 12) {
                VStack(spacing: 16) {
                    buildPointsView()
                    buildDetailView()
                }
                .padding(16)
                .background(ColorAssets.neutralLight.swiftUIColor)
                .cornerRadius(12)

//                buildProgressVideo()
            }
            .padding(16)
        }
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
    }

    private func buildPointsView() -> some View {
        VStack(spacing: 8) {
            Text(viewModel.model?.type ?? "")
                .dynamicFont(.systemFont(ofSize: 16))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            Text(viewModel.model?.point ?? "")
                .dynamicFont(.systemFont(ofSize: 22, weight: .bold))
                .foregroundColor(Color(viewModel.model?.pointColor ?? ""))
        }
    }

    private func buildDetailView() -> some View {
        VStack(spacing: 8) {
            buildItemDetail(title: L10n.transactionDetailStatus, content: viewModel.model?.status ?? "", isStatus: true)

            buildItemDetail(title: L10n.transactionDetailType, content: viewModel.model?.reason ?? "")

            buildItemDetail(title: L10n.transactionDetailTime, content: viewModel.model?.dateTime ?? "")

            buildItemDetail(title: L10n.transactionDetailCode, content: viewModel.model?.code ?? "")
        }
    }

    private func buildItemDetail(title: String, content: String, isStatus: Bool = false) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .dynamicFont(.systemFont(ofSize: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            if isStatus {
                Text(content)
                    .dynamicFont(.systemFont(ofSize: 14))
                    .frame(height: 24)
                    .padding(.horizontal, 10)
                    .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                    .background(ColorAssets.systemGreen.swiftUIColor)
                    .cornerRadius(20)
            } else {
                Text(content)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }
    }

    private func buildProgressVideo() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.transactionDetailVideoName)
                .dynamicFont(.systemFont(ofSize: 14))
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Text("개그맨 박준형 “내가 내 아내 김지혜씨와 안싸우는 이유...?” (feat.갈갈이 패밀리)")
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))

            HStack {
                Text(L10n.transactionComplateState)
                    .dynamicFont(.systemFont(ofSize: 14))
                Spacer()
                Text(L10n.minutes(10) + "/" + L10n.minutes(10))
                    .dynamicFont(.systemFont(ofSize: 14))
            }

            ProgressView(value: 1, total: 1)
                .tintColor(ColorAssets.primaryGreen100.swiftUIColor)

            HStack {
                Text("100%")
                    .dynamicFont(.systemFont(ofSize: 14))
                Spacer()
                ImageAssets.icQuestion.swiftUIImage
                    .resizable()
                    .frame(width: 16, height: 16)
            }

            Button(L10n.transactionComplateNow) {}
                .buttonStyle(PrimaryButtonStyle(isEnabled: false))
                .padding(.top, 8)
        }
        .padding(16)
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(12)
    }
}
