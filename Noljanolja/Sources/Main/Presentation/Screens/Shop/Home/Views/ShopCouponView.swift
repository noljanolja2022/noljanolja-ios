//
//  ShopCouponView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//

import SwiftUI

// MARK: - ShopCouponView

struct ShopCouponView: View {
    var model: [Coupon]
    var selectAction: ((Coupon) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 12) {
            Text(L10n.commonShop)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: Array(repeating: GridItem.flexible(spacing: 12), count: 2)) {
                ForEach(model.indices, id: \.self) {
                    let model = model[$0]
                    ShopCouponItemView(model: model)
                        .onTapGesture { selectAction?(model) }
                }
            }
        }
    }
}
