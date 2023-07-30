//
//  TransactionHistoryItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import SwiftUI

struct TransactionHistoryItemView: View {
    let model: TransactionHistoryItemModel
    let titleColor: Color

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 8) {
            VStack(spacing: 8) {
                Text(model.title)
                    .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(titleColor)
                Text(model.dateTime)
                    .dynamicFont(.systemFont(ofSize: 8, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
            Text(model.point)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .foregroundColor(Color(model.pointColor))
        }
        .padding(16)
    }
}
