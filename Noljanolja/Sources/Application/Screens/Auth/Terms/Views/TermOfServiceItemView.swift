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
    var foregroundColor: Color? = ColorAssets.neutralDeepGrey.swiftUIColor
    var checkedForegroundColor: Color? = ColorAssets.primaryYellowMain.swiftUIColor
    var idArrowIconHidden = false
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(
                action: { selected = !selected },
                label: {
                    if selected {
                        ImageAssets.icChecked.swiftUIImage
                            .resizable()
                    } else {
                        ImageAssets.icUnchecked.swiftUIImage
                            .resizable()
                    }
                }
            )
            .frame(width: 22, height: 22)
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
                            .font(.system(size: 16))
                            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                        Spacer(minLength: 4)

                        if !idArrowIconHidden {
                            ImageAssets.icArrowRight.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
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
