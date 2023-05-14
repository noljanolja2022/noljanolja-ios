//
//  TabBarView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/05/2023.
//

import SwiftUI

// MARK: - TabItemView

struct TabItemView: View {
    let imageName: String
    let title: String
    var hasNew = false

    var action: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        Button(
            action: {
                action?()
            }, label: {
                buildContentView()
            }
        )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 4) {
            ZStack(alignment: .topTrailing) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Spacer()
                    .frame(width: 6, height: 6)
                    .background(ColorAssets.systemRed100.swiftUIColor)
                    .cornerRadius(3)
                    .padding(2)
                    .background(ColorAssets.systemRed100.swiftUIColor.opacity(0.5))
                    .cornerRadius(5)
                    .padding(.top, -3)
                    .padding(.trailing, -3)
                    .hidden(!hasNew)
            }

            Text(title)
                .lineLimit(1)
                .font(.system(size: 10))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - TabItemView_Previews

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(
            imageName: MainTabType.chat.imageName,
            title: "String",
            hasNew: true
        )
    }
}
