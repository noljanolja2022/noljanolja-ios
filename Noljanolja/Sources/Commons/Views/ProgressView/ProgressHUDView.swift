//
//  CustomProgressView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/02/2023.
//

import SwiftUI

// MARK: - ProgressHUBState

final class ProgressHUBState: ObservableObject {
    @Published var isLoading = false
}

// MARK: - ProgressHUDView

struct ProgressHUDView: View {
    var body: some View {
        HStack {
            ProgressView()
                .scaleEffect(2)
                .frame(width: 80, height: 80)
                .progressViewStyle(CircularProgressViewStyle(tint: ColorAssets.black.swiftUIColor))
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
        .ignoresSafeArea()
    }
}

// MARK: - ProgressHUDView_Previews

struct ProgressHUDView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressHUDView()
    }
}
