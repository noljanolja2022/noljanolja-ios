//
//  ChatSettingItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import SwiftUI

// MARK: - ChatSettingItemView

struct ChatSettingItemView: View {
    let itemModel: ChatSettingItemModel

    var body: some View {
        HStack(spacing: 12) {
            Image(itemModel.image)
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(itemModel.title)
                .font(.system(size: 13))
                .frame(maxWidth: .infinity, alignment: .leading)
            ImageAssets.icArrowRight.swiftUIImage
                .frame(width: 24, height: 24)
        }
        .background(ColorAssets.white.swiftUIColor)
    }
}

// MARK: - ChatSettingItemView_Previews

struct ChatSettingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingItemView(
            itemModel: .updateTitle
        )
    }
}
