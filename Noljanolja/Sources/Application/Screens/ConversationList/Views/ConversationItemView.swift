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
    var avatar: String?
    var name: String?
    var lastMessage: String?

    var body: some View {
        HStack(spacing: 16) {
            KFImage(URL(string: avatar ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 52)
                .background(Color.gray)
                .cornerRadius(20)

            VStack(alignment: .leading, spacing: 8) {
                Text(name ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 16).bold())
                    .foregroundColor(.black)
                Text(lastMessage ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 14))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

// MARK: - ConversationItemView_Previews

struct ConversationItemView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationItemView(
            avatar: "https://upload.wikimedia.org/wikipedia/en/8/86/Avatar_Aang.png",
            name: "ToRing",
            lastMessage: "Hi, everyone"
        )
    }
}
