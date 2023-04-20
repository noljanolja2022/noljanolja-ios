//
//  ChatDateItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import SwiftUI

// MARK: - ChatDateItemView

struct ChatDateItemView: View {
    let model: ChatDateItemModel

    var body: some View {
        Text(model.message)
            .font(.system(size: 11, weight: .medium))
            .frame(height: 26)
            .padding(.horizontal, 12)
            .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
            .background(ColorAssets.neutralBlueGrey.swiftUIColor)
            .cornerRadius(6)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 16)
    }
}
