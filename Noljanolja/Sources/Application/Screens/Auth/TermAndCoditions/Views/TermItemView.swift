//
//  TermItem.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import SwiftUI

// MARK: - TermItemView

struct TermItemView: View {
    @Binding var selected: Bool
    var title = ""
    var description = ""
    var foregroundColor: Color? = ColorAssets.gray.swiftUIColor
    var checkedForegroundColor: Color? = ColorAssets.highlightPrimary.swiftUIColor
    var idArrowIconHidden = false
    var minTitleWidth: CGFloat = 0

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Button(
                action: { selected = !selected },
                label: {
                    ImageAssets.icCheckCircle.swiftUIImage
                        .resizable()
                        .renderingMode(.template)
                }
            )
            .frame(width: 32, height: 32)
            .foregroundColor(
                selected ? checkedForegroundColor : foregroundColor
            )
            .alignmentGuide(.top, computeValue: { _ in 4 })
            Text(title)
                .frame(minWidth: minTitleWidth, alignment: .leading)
                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 14))
                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
            Text(description)
                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 14))
                .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
            Spacer(minLength: 4)
            if !idArrowIconHidden {
                ImageAssets.icArrowRight.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .alignmentGuide(.top, computeValue: { _ in 4 })
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - TermItemView_Previews

struct TermItemView_Previews: PreviewProvider {
    @State private static var selected = true

    static var previews: some View {
        VStack {
            TermItemView(
                selected: $selected,
                title: "[Essential]",
                description: "Subscribe Terms of Service"
            )
            TermItemView(
                selected: $selected,
                title: "[Select]",
                description: "Subscribe Terms of Service Terms of ServiceSubscribe Terms of Service Terms of Service"
            )
        }
    }
}
