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
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Button(
                action: {
                    viewAllAction?()
                },
                label: {
                    HStack(spacing: 8) {
                        Text("View all")
                            .font(.system(size: 16, weight: .bold))
                        ImageAssets.icArrowRight.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .foregroundColor(ColorAssets.neutralRawLight.swiftUIColor)
                }
            )
        }
        .padding(.horizontal, 16)
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