//
//  ConversationItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import Kingfisher
import SwiftUI

// MARK: - ConversationItemView

struct ConversationItemView: View {
    var model: ConversationItemModel

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            KFImage(URL(string: model.image ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(14)

            VStack(alignment: .leading, spacing: 8) {
                Text(model.title ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                let message: String? = {
                    switch model.lastMessage?.type {
                    case .plaintext: return model.lastMessage?.message
                    case .photo: return "Photo"
                    case .sticker: return "Sticker"
                    case .gif, .document, .none: return nil
                    }
                }()
                if let message, !message.isEmpty {
                    Text(message)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(size: 14, weight: .regular))
                        .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                }
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .trailing, spacing: 2) {
                Text(model.date ?? "")
                    .lineLimit(1)
                    .font(Font.system(size: 12, weight: .regular))
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                if !model.isSeen {
                    Text("")
                        .frame(width: 6, height: 6)
                        .background(Color(hexadecimal: "BA1B1B"))
                        .cornerRadius(3)
                }
            }
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
}

// MARK: - ConversationItemView_Previews

struct ConversationItemView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationItemView(
            model: ConversationItemModel(
                id: 0,
                image: "https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg",
                title: "Title",
                lastMessage: Message(
                    id: 0,
                    conversationID: 0,
                    message: "Last message\nLast message\nLast message",
                    type: .plaintext,
                    sender: User(
                        id: "",
                        name: "name",
                        avatar: "",
                        pushToken: "",
                        phone: "",
                        email: "",
                        isEmailVerified: false,
                        dob: nil,
                        gender: .male,
                        preferences: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    ),
                    seenBy: [],
                    attachments: [],
                    createdAt: Date()
                ),
                date: "06:12",
                isSeen: false
            )
        )
    }
}
