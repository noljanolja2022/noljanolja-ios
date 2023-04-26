//
//  ChatSettingParticipantItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ChatSettingParticipantItemView

struct ChatSettingParticipantItemView: View {
    var model: ChatSettingParticipantModel

    var body: some View {
        HStack(spacing: 16) {
            WebImage(
                url: URL(string: model.avatar),
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
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(14)
            VStack(spacing: 0) {
                if let displayName = model.displayName {
                    Text(displayName)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                if let originalName = model.originalName {
                    Text(originalName)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                }
            }

            if model.isAdmin {
                Text("Admin")
                    .font(.system(size: 12, weight: .bold))
                    .frame(height: 26)
                    .padding(.horizontal, 12)
                    .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                    .background(ColorAssets.green.swiftUIColor)
                    .cornerRadius(13)
            }
        }
    }
}

// MARK: - ChatSettingParticipantItemView_Previews

struct ChatSettingParticipantItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingParticipantItemView(
            model: ChatSettingParticipantModel(
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
        )
    }
}