//
//  RoundedLinearProgressViewStyle.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import SwiftUI

// MARK: - RoundedLinearProgressViewStyle

struct RoundedLinearProgressViewStyle: ProgressViewStyle {
    let foregroundColor: Color
    let backgroundColor: Color
    let radius: CGFloat

    init(foregroundColor: Color = ColorAssets.highlightPrimary.swiftUIColor,
         backgroundColor: Color = ColorAssets.gray.swiftUIColor,
         radius: CGFloat = 5) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.radius = radius
    }

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            let fractionCompletedWidth = geometry.size.width * (configuration.fractionCompleted ?? 0)
            VStack(alignment: .leading, spacing: 0) {
                ImageAssets.icBicycle.swiftUIImage
                    .resizable()
                    .frame(width: 32, height: 32, alignment: .leading)
                    .padding(
                        .leading,
                        min(max(fractionCompletedWidth - 16, 0), geometry.size.width - 32)
                    )
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: radius)
                        .frame(width: geometry.size.width, height: radius * 2)
                        .foregroundColor(backgroundColor)

                    RoundedRectangle(cornerRadius: radius)
                        .frame(width: fractionCompletedWidth, height: radius * 2)
                        .foregroundColor(foregroundColor)
                }
            }
        }
    }
}

// MARK: - TestRoundedLinearProgressViewStyle_Previews

struct TestRoundedLinearProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 2, total: 5)
            .progressViewStyle(RoundedLinearProgressViewStyle())
            .frame(height: 42)
            .background(Color.gray)
    }
}
