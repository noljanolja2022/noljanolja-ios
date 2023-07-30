//
//  CustomProgressView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/02/2023.
//

import SwiftUI
import SwiftUIX

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
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
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

// MARK: - ProgressHUBVisibleKey

struct ProgressHUBVisibleKey: EnvironmentKey {
    static let defaultValue = Binding<Bool>.constant(false)
}

extension EnvironmentValues {
    var isProgressHUBVisible: Binding<Bool> {
        get { self[ProgressHUBVisibleKey.self] }
        set { self[ProgressHUBVisibleKey.self] = newValue }
    }
}

extension View {
    func isProgressHUBVisible(_ isVisible: Binding<Bool>) -> some View {
        windowOverlay(isVisible: isVisible) {
            ProgressView()
                .scaleEffect(2)
                .padding(52)
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.2))
                .ignoresSafeArea()
        }
    }
}
