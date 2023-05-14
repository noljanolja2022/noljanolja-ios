//
//  EventMessageView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/04/2023.
//

import SwiftUI

// MARK: - EventMessageView

struct EventMessageView: View {
    let model: EventMessageModel

    var body: some View {
        Text(model.message)
            .font(.system(size: 14, weight: .medium))
            .frame(height: 26)
            .padding(.horizontal, 12)
            .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
            .background(ColorAssets.neutralBlueGrey.swiftUIColor)
            .cornerRadius(6)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 6)
    }
}
