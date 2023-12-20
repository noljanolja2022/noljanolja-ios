//
//  AvatarView.swift
//  Noljanolja
//
//  Created by duydinhv on 20/12/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - AvatarView

struct AvatarView: View {
    let url: String?
    let size: CGSize
    var isRound = true
    var body: some View {
        WebImage(
            url: URL(string: url ?? ""),
            options: .refreshCached,
            context: [
                .imageTransformer: SDImageResizingTransformer(
                    size: CGSize(width: size.width * 3, height: size.height * 3),
                    scaleMode: .aspectFill
                )
            ]
        )
        .resizable()
        .placeholder(ImageAssets.icAvatarPlaceholder.swiftUIImage)
        .indicator(.activity)
        .scaledToFill()
        .frame(size)
        .cornerRadius(isRound ? size.width / 2 : 0)
    }
}

// MARK: - AvatarView_Preview

struct AvatarView_Preview: PreviewProvider {
    static var previews: some View {
        AvatarView(url: nil, size: .init(width: 10, height: 10))
    }
}
