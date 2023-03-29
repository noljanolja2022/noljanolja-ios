//
//  MessageStatusView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/03/2023.
//

import Kingfisher
import SwiftUI

// MARK: - MessageStatusView

struct MessageStatusView: View {
    var status: ChatMessageItemModel.StatusType

    var body: some View {
        ZStack {
            switch status {
            case .none:
                EmptyView()
            case .sending:
                Text("")
                    .frame(width: 10, height: 10)
                    .overlayBorder(color: ColorAssets.neutralDarkGrey.swiftUIColor, cornerRadius: 5, lineWidth: 1)
            case .received:
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .sizeToFit()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            case let .seen(users):
                KFImage(URL(string: users.first?.avatar ?? "")).placeholder {
                    ImageAssets.icAvatarPlaceholder.swiftUIImage
                        .resizable()
                }
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: 12, height: 12)
        .cornerRadius(6)
    }
}

// MARK: - MessageStatusView_Previews

struct MessageStatusView_Previews: PreviewProvider {
    static var previews: some View {
        MessageStatusView(status: .received)
    }
}
