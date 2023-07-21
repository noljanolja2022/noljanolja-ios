//
//  ChatSettingItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import SwiftUI

// MARK: - ChatSettingItemView

struct ChatSettingItemView: View {
    let itemModel: ChatSettingItemModelType

    var body: some View {
        HStack(spacing: 12) {
            Image(itemModel.image)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Text(itemModel.title)
                .font(.system(size: 13))
                .frame(maxWidth: .infinity, alignment: .leading)
            ImageAssets.icArrowRight.swiftUIImage
                .frame(width: 20, height: 20)
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

// MARK: - ChatSettingItemView_Previews

struct ChatSettingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingItemView(
            itemModel: .adjustment
        )
    }
}
