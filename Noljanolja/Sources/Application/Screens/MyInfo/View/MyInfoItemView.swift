//
//  MyInfoItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/02/2023.
//

import SwiftUI

// MARK: - MyInfoItemView

struct MyInfoItemView: View {
    var title = ""
    var hasArrowImage = true

    var body: some View {
        HStack {
            Text(title)
                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
            Spacer()
            if hasArrowImage {
                ImageAssets.icArrowRight.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .frame(height: 52)
    }
}

// MARK: - MyInfoItemView_Previews

struct MyInfoItemView_Previews: PreviewProvider {
    static var previews: some View {
        MyInfoItemView()
    }
}
