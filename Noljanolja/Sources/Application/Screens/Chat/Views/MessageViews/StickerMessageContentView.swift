//
//  StickerMessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/03/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - StickerMessageContentView

struct StickerMessageContentView: View {
    var contentItemModel: StickerMessageContentModel
    
    var body: some View {
        AnimatedImage(
            url: contentItemModel.sticker,
            isAnimating: .constant(true)
        )
        .resizable()
        .indicator(.activity)
        .scaledToFit()
        .frame(width: 95, height: 95)
    }
}

// MARK: - StickerMessageContentView_Previews

struct StickerMessageContentView_Previews: PreviewProvider {
    static var previews: some View {
        StickerMessageContentView(
            contentItemModel: StickerMessageContentModel(
                isSenderMessage: true,
                sticker: nil
            )
        )
    }
}
