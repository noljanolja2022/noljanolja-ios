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
                if let lastMessage = model.lastMessage, !lastMessage.isEmpty {
                    Text(lastMessage)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(size: 14, weight: .regular))
                        .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                }
            }
            .frame(maxWidth: .infinity)

            Text(model.date ?? "")
                .lineLimit(1)
                .frame(height: 40)
                .font(Font.system(size: 12, weight: .regular))
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
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
                lastMessage: "Last message\nLast message\nLast message",
                date: "06:12"
            )
        )
    }
}
