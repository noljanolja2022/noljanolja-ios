//
//  TransactionHistoryFilterView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//

import SwiftUI

// MARK: - TransactionHistoryFilterView

struct TransactionHistoryFilterView: View {
    @Binding var selectedType: TransactionType
    let types: [TransactionType]

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 12) {
            ForEach(types.indices, id: \.self) { index in
                let type = types[index]
                TransactionHistoryFilterItemView(
                    type: type,
                    isSelected: selectedType == type,
                    action: {
                        selectedType = type
                    }
                )
            }
        }
    }
}

// MARK: - TransactionHistoryFilterItemView

struct TransactionHistoryFilterItemView: View {
    let type: TransactionType
    let isSelected: Bool
    var action: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        Button(
            action: {
                action?()
            },
            label: {
                Text(type.title)
                    .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .foregroundColor(
                        isSelected
                            ? ColorAssets.neutralDarkGrey.swiftUIColor
                            : ColorAssets.neutralDeeperGrey.swiftUIColor
                    )
                    .background(
                        isSelected
                            ? AppThemeManager.shared.theme.primary100
                            : Color.clear
                    )
                    .border(
                        ColorAssets.neutralDeeperGrey.swiftUIColor,
                        width: isSelected ? 0 : 1,
                        cornerRadius: 4
                    )
            }
        )
    }
}
