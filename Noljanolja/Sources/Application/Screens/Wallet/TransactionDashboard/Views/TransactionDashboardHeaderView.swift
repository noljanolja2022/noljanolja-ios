//
//  TransactionDashboardHeaderView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import SwiftUI

struct TransactionDashboardHeaderView: View {
    let model: TransactionDashboardHeaderModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 8) {
            Text(model.weekday)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Text(model.date)
                .font(.system(size: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
        .padding(16)
        .background(ColorAssets.primaryGreen50.swiftUIColor)
    }
}
