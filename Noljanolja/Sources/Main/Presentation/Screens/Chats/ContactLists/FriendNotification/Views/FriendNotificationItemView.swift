//
//  FriendNotificationItemView.swift
//  Noljanolja
//
//  Created by Duy Dinh on 15/01/2024.
//

import SwiftUI

struct FriendNotificationItemView: View {
    let model: FriendNotificationItemModel
    let titleColor: Color

    var body: some View {
        HStack(spacing: 8) {
            VStack(spacing: 8) {
                Text(model.title)
                    .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(titleColor)
                Text(model.dateTime)
                    .dynamicFont(.systemFont(ofSize: 8, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
            Spacer()
            Button {
                //
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(-90))
                    .frame(width: 24, height: 24)
            }
        }
        .padding(16)
    }
}
