//
//  ChatEventItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//

import SwiftUI

// MARK: - ChatEventItemView

struct ChatEventItemView: View {
    let model: EventChatItemModel

    var body: some View {
        Text(model.message)
            .font(.system(size: 11, weight: .medium))
            .frame(height: 26)
            .padding(.horizontal, 12)
            .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(13)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 4)
    }
}
