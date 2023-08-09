//
//  AddReferralAlertView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/08/2023.
//
//

import SwiftUI

// MARK: AddReferralAlertView

struct AddReferralAlertView<ViewModel: AddReferralAlertViewModel>: View {
    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

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

    private func buildMainView() -> some View {
        VStack(spacing: 64) {
            buildRewardView()
            buildButtonView()
        }
        .padding(.top, 64)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }

    private func buildRewardView() -> some View {
        VStack(spacing: 12) {
            ImageAssets.icPoint.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            Text(L10n.transactionHistoryPoint(viewModel.rewardPoints.signFormatted()))
                .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
            Text("Congratulation! You and your friend have just got \(viewModel.rewardPoints.formatted()) Points from referal code.")
                .dynamicFont(.systemFont(ofSize: 14))
                .lineLimit(nil)
                .multilineTextAlignment(.center)
        }
    }

    private func buildButtonView() -> some View {
        Button(
            L10n.commonOk.uppercased(),
            action: {
                presentationMode.wrappedValue.dismiss()
                viewModel.action.send(())
            }
        )
        .buttonStyle(PrimaryButtonStyle())
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
    }
}
