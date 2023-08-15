//
//  MyCouponView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/06/2023.
//

import SwiftUI

// MARK: - MyCouponView

struct MyCouponView: View {
    var model: [MyCoupon]
    var viewAllAction: (() -> Void)?
    var selectAction: ((MyCoupon) -> Void)?
    
    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 12) {
            buildHeaderView()
            buildListView()
        }
    }

    private func buildHeaderView() -> some View {
        HStack(spacing: 8) {
            Text("Exchanged Coupons")
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Button(
                action: {
                    viewAllAction?()
                },
                label: {
                    HStack(spacing: 8) {
                        Text("View all")
                            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        ImageAssets.icArrowRight.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            )
        }
        .padding(.horizontal, 16)
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }

    private func buildListView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(model.indices, id: \.self) {
                    let model = model[$0]
                    MyCouponItemView(
                        model: model,
                        selectAction: { selectAction?(model) }
                    )
                    .frame(width: 120)
                    .onTapGesture { selectAction?(model) }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
