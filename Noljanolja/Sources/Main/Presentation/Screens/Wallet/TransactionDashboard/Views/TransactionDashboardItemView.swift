//
//  TransactionDashboardItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/05/2023.
//

import SwiftUI

struct TransactionDashboardItemView: View {
    let model: TransactionDashboardItemModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 8) {
            Text(model.title)
                .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Text(model.point)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .foregroundColor(Color(model.pointColor))
        }
        .padding(16)
    }
}
