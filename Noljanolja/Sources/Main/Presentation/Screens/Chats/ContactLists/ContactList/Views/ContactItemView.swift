//
//  ContactItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUIX

// MARK: - VerticalContactItemView

struct VerticalContactItemView: View {
    var user: User
    var isSelected: Bool?
    var isNotification = false

    var body: some View {
        HStack(spacing: 12) {
            WebImage(
                url: URL(string: user.avatar),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 40 * 3, height: 40 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 40, height: 40)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(14)
            .overlay(
                Circle()
                    .fill(ColorAssets.systemRed50.swiftUIColor)
                    .frame(width: 13, height: 13)
                    .overlay(Circle().inset(by: -1).stroke(.white, lineWidth: 2))
                    .offset(.init(x: 5, y: -3))
                    .hidden(!isNotification),
                alignment: .topTrailing
            )

            Text(user.name ?? "")
                .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            switch isSelected {
            case .some(true):
                ImageAssets.icCheckboxCircleChecked.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
            case .some(false):
                ImageAssets.icCheckboxCircleUnchecked.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            case .none:
                EmptyView()
            }
        }
        .padding(16)
    }
}

// MARK: - HorizontalContactItemView

struct HorizontalContactItemView: View {
    var user: User

    var body: some View {
        VStack(spacing: 8) {
            WebImage(
                url: URL(string: user.avatar),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 40 * 3, height: 40 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 40, height: 40)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(14)

            Text(user.name ?? "")
                .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(alignment: .center)
        }
        .padding(16)
    }
}
