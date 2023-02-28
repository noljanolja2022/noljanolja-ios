//
//  TermOfServiceItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//

import SwiftUI

// MARK: - TermOfServiceItemView

struct TermOfServiceItemView: View {
    @Binding var selected: Bool
    var title = ""
    var titleLineLimit: Int? = 1
    var foregroundColor: Color? = ColorAssets.forcegroundSecondary.swiftUIColor
    var checkedForegroundColor: Color? = ColorAssets.highlightPrimary.swiftUIColor
    var idArrowIconHidden = false
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
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
            Button(
                action: { action?() },
                label: {
                    HStack(alignment: .center, spacing: 6) {
                        Text(title)
                            .frame(alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .lineLimit(titleLineLimit)
                            .font(FontFamily.NotoSans.medium.swiftUIFont(size: 14))
                            .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                        Spacer(minLength: 4)

                        if !idArrowIconHidden {
                            ImageAssets.icArrowRight.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                        }
                    }
                }
            )
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - TermOfServiceItemView_Previews

struct TermOfServiceItemView_Previews: PreviewProvider {
    static var previews: some View {
        TermOfServiceItemView(
            selected: .constant(false),
            title: "I'm 14 years old older"
        )
    }
}
