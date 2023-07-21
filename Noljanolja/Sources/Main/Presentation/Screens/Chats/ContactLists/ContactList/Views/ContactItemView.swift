//
//  ContactItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ContactItemView

struct ContactItemView: View {
    var user: User
    var isSelected: Bool?

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

            Text(user.name ?? "")
                .font(.system(size: 16, weight: .medium))
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

// MARK: - ContactItemView_Previews

struct ContactItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContactItemView(
            user: User(
                id: "",
                name: nil,
                avatar: nil,
                pushToken: nil,
                phone: nil,
                email: nil,
                isEmailVerified: false,
                dob: nil,
                gender: nil,
                preferences: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        )
    }
}
