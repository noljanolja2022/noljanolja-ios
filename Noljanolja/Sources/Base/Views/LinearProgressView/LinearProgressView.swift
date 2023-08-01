//
//  LinearProgressView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import SwiftUI

// MARK: - LinearProgressView

struct LinearProgressView: View {
    let progress: CGFloat

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ColorAssets.neutralRawLightGrey.swiftUIColor)
                    .cornerRadius(proxy.size.height / 2.0)
                Spacer()
                    .frame(maxHeight: .infinity)
                    .frame(width: min(max(0.0, progress), 1.0) * proxy.size.width)
                    .background(ColorAssets.secondaryYellow200.swiftUIColor)
                    .cornerRadius(proxy.size.height / 2.0)
            }
        }
    }
}
