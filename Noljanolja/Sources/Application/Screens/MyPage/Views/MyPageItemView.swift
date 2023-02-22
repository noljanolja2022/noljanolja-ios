//
//  MyPageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/02/2023.
//

import SwiftUI

// MARK: - MyPageItemView

struct MyPageItemView: View {
    var image: UIImage?
    var title: String
    var titleFont: Font = FontFamily.NotoSans.medium.swiftUIFont(size: 16)
    var subTitle: String?
    var hasArrowImage = true
    var action: (() -> Void)?
    
    var body: some View {
        Button(
            action: { action?() },
            label: {
                HStack(spacing: 16) {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 14)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(titleFont)
                            .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                        if let subTitle {
                            Text(subTitle)
                                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16)).foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                        }
                    }
                    Spacer()
                    if hasArrowImage {
                        ImageAssets.icArrowRight.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 14)
                    }
                }
                .frame(height: 64)
            }
        )
    }
}

// MARK: - MyPageItemView_Previews

struct MyPageItemView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
