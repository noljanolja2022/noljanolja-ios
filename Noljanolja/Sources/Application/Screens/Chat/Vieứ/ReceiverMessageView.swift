//
//  ReceiverMessageView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Kingfisher
import SwiftUI

// MARK: - ReceiverMessageView

struct ReceiverMessageView: View {
    var messageItemModel: MessageItemModel

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            KFImage(URL(string: messageItemModel.avatar ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 24, height: 24)
                .background(ColorAssets.neutralGrey.swiftUIColor)
                .cornerRadius(12)

            HStack(alignment: .bottom, spacing: 4) {
                MessageContentView(messageContent: messageItemModel.content)
                
                Text(messageItemModel.date)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
            }

            Spacer(minLength: 92)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - ReceiverMessageView_Previews

struct ReceiverMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverMessageView(
            messageItemModel: MessageItemModel(
                id: 0,
                isSenderMessage: true,
                avatar: "https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg",
                date: "06:00",
                content: .plaintext(PlaintextMessageContentItemModel(
                    isSenderMessage: true,
                    message: "Hello, world"
                ))
            )
        )
    }
}
