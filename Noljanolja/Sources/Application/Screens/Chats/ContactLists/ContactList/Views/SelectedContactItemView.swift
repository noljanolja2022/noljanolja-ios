//
//  SelectedContactItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - SelectedContactItemView

struct SelectedContactItemView: View {
    let user: User
    var action: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            WebImage(
                url: URL(string: user.avatar),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 50 * 3, height: 50 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 50, height: 50)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(14)
            .padding(.trailing, 6)
            Button(
                action: {
                    action?()
                },
                label: {
                    ImageAssets.icClose.swiftUIImage
                        .resizable()
                        .padding(6)
                        .frame(width: 20, height: 20)
                        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                        .background(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .cornerRadius(10)
                }
            )
        }
    }
}

// MARK: - SelectedContactItemView_Previews

struct SelectedContactItemView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedContactItemView(
            user: User(
                id: "",
                name: "Test",
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
