//
//  CheckinProgressSumaryView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import SwiftUI

// MARK: - CheckinProgressSumaryView

struct CheckinProgressSumaryView: View {
    let completedCount: Int
    let count: Int
    let forcegroundColor: Color
    let secondaryForcegroundColor: Color

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 4) {
            buildTextView()
            buildProgressView()
        }
    }

    private func buildTextView() -> some View {
        HStack(spacing: 8) {
            Text(L10n.walletMyAttendance)
                .dynamicFont(.systemFont(ofSize: 12, weight: .bold))
                .foregroundColor(forcegroundColor)

            Spacer()

            HStack(spacing: 4) {
                Text(String(completedCount))
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(forcegroundColor)

                Text("/")
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .foregroundColor(forcegroundColor)

                Text(String(count))
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .foregroundColor(secondaryForcegroundColor)
            }
        }
    }

    private func buildProgressView() -> some View {
        LinearProgressView(
            progress: CGFloat(completedCount) / CGFloat(count)
        )
        .frame(height: 6)
    }
}
