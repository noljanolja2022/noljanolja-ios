//
//  DialogView.swift
//  Noljanolja
//
//  Created by kii on 22/01/2024.
//

import SwiftUI
import SwiftUINavigation

// MARK: - DialogModel

struct DialogModel {
    let image: Image?
    let title: String
    let message: String?
    let primaryTitle: String?
    let primaryAction: (() -> Void)?
    let secondaryTitle: String?
    let secondaryAction: (() -> Void)?

    init(image: Image?,
         title: String,
         message: String? = nil,
         primaryTitle: String? = nil,
         primaryAction: (() -> Void)? = nil,
         secondaryTitle: String? = nil,
         secondaryAction: (() -> Void)? = nil) {
        self.image = image
        self.title = title
        self.message = message
        self.primaryTitle = primaryTitle
        self.primaryAction = primaryAction
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
    }
}

// MARK: - DialogView

struct DialogView: View {
    let model: DialogModel
    @EnvironmentObject var themeManager: AppThemeManager

    var body: some View {
        VStack(spacing: 24) {
            if let image = model.image {
                image
                    .resizable()
                    .height(140)
            } else {
                Spacer()
                    .height(24)
            }

            Group {
                VStack(spacing: 8) {
                    Text(model.title)
                        .dynamicFont(.systemFont(ofSize: 20, weight: .medium))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)

                    Text(model.message ?? "")
                        .dynamicFont(.systemFont(ofSize: 16))
                        .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }

                HStack(spacing: 24) {
                    Spacer()

                    if let titleSecondary = model.secondaryTitle {
                        Button(titleSecondary) {
                            model.secondaryAction?()
                        }
                        .foregroundColor(themeManager.theme.primary200)
                    }

                    if let titlePrimary = model.primaryTitle {
                        Button(titlePrimary) {
                            model.primaryAction?()
                        }
                        .foregroundColor(themeManager.theme.primary200)
                    }
                }
                .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
                .padding(.top, 8)
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 20)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
        .padding(.horizontal, 40)
    }
}
