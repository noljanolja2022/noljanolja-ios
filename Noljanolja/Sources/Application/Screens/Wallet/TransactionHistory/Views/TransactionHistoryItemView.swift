//
//  TransactionHistoryItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import SwiftUI

struct TransactionHistoryItemView: View {
    let model: TransactionHistoryItemModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 8) {
            VStack(spacing: 8) {
                Text(model.title)
                    .font(.system(size: 11, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text(model.dateTime)
                    .font(.system(size: 8, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
            Text(model.point)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(model.pointColor))
        }
        .padding(16)
    }
}
