//
//  ChatSettingAddParticipantView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//

import SwiftUI

// MARK: - ChatSettingAddParticipantView

struct ChatSettingAddParticipantView: View {
    var body: some View {
        HStack(spacing: 16) {
            ImageAssets.icAdd.swiftUIImage
                .resizable()
                .padding(6)
                .frame(width: 40, height: 40)
                .foregroundColor(ColorAssets.primaryMain.swiftUIColor)
                .overlayBorder(
                    color: ColorAssets.neutralLightGrey.swiftUIColor,
                    cornerRadius: 14,
                    lineWidth: 1
                )
            Text("Add member")
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.primaryMain.swiftUIColor)
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

// MARK: - ChatSettingAddParticipantView_Previews

struct ChatSettingAddParticipantView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingAddParticipantView()
    }
}
