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
    let forcegroundColor: Color
    let backgroundColor: Color

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backgroundColor)
                    .cornerRadius(proxy.size.height / 2.0)
                Spacer()
                    .frame(maxHeight: .infinity)
                    .frame(width: min(max(0.0, progress), 1.0) * proxy.size.width)
                    .background(forcegroundColor)
                    .cornerRadius(proxy.size.height / 2.0)
            }
        }
    }
}
