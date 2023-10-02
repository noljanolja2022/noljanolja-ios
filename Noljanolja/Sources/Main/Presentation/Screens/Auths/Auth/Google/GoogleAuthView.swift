//
//  GoogleAuthView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/10/2023.
//
//

import SwiftUI

// MARK: - GoogleAuthView

struct GoogleAuthView<ViewModel: GoogleAuthViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .onAppear {
                viewModel.isAppearSubject.send(true)
            }
            .onDisappear {
                viewModel.isAppearSubject.send(false)
            }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildMainView() -> some View {
        buildContentView()
    }

    private func buildContentView() -> some View {
        VStack(spacing: 32) {
            ImageAssets.logo.swiftUIImage
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)

            Button(
                "Login with Google",
                action: {
                    viewModel.action.send()
                }
            )
            .buttonStyle(PrimaryButtonStyle())
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        }
        .padding(32)
    }
}

// MARK: - GoogleAuthView_Previews

struct GoogleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuthView(viewModel: GoogleAuthViewModel())
    }
}
