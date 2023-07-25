//
//  CouponKeywordItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//

import SwiftUI

// MARK: - CouponKeywordItemView

struct CouponKeywordItemView: View {
    var model: CouponKeyword
    var removeAction: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(spacing: 16) {
            ImageAssets.icTimeRecent.swiftUIImage
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)

            Text(model.keyword)
                .dynamicFont(.systemFont(ofSize: 14))
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorAssets.neutralLight.swiftUIColor)

            Button(
                action: {
                    removeAction?()
                },
                label: {
                    ImageAssets.icClose.swiftUIImage
                        .resizable()
                        .padding(4)
                        .frame(width: 20, height: 20)
                        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                        .background(ColorAssets.neutralGrey.swiftUIColor)
                        .cornerRadius(10)
                }
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}
