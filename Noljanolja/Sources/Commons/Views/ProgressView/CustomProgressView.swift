//
//  CustomProgressView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/02/2023.
//

import SwiftUI

// MARK: - CustomProgressView

struct CustomProgressView: View {
    var body: some View {
        HStack {
            ProgressView()
                .scaleEffect(2)
                .frame(width: 72, height: 72)
                .progressViewStyle(CircularProgressViewStyle(tint: ColorAssets.black.swiftUIColor))
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.1))
        .ignoresSafeArea()
    }
}

// MARK: - CustomProgressView_Previews

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
