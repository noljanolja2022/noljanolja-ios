//
//  DateChatItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import SwiftUI

// MARK: - DateChatItemView

struct DateChatItemView: View {
    let model: DateChatItemModel

    var body: some View {
        Text(model.message)
            .font(.system(size: 14, weight: .medium))
            .frame(height: 26)
            .padding(.horizontal, 12)
            .foregroundColor(ColorAssets.neutralRawLight.swiftUIColor)
            .background(ColorAssets.neutralBlueGrey.swiftUIColor)
            .cornerRadius(6)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 12)
    }
}
