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
            .hideNavigationBar()
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
            .background(
                ColorAssets.neutralLight.swiftUIColor
                    .ignoresSafeArea()
                    .overlay {
                        ColorAssets.primaryGreen200.swiftUIColor
                            .ignoresSafeArea(edges: .top)
                    }
            )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()
            buildAuthView()
        }
    }

    private func buildHeaderView() -> some View {
        ImageAssets.logo.swiftUIImage
            .resizable()
            .scaledToFill()
            .frame(width: 126, height: 114)
            .padding(32)
    }

    private func buildAuthView() -> some View {
        VStack(spacing: 8) {
            ScrollView {
                VStack(spacing: 24) {
                    buildAuthHeaderView()
                    buildAuthContentView()
                }
                .padding(.horizontal, 16)
                .padding(.top, 28)
            }
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius([.topLeading, .topTrailing], 40)
    }

    private func buildAuthHeaderView() -> some View {
        VStack(spacing: 4) {
            Text(L10n.commonLogin)
                .dynamicFont(.systemFont(ofSize: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Text("Welcome to Nolja Nolja. Please connect your Google account to continue.")
                .dynamicFont(.systemFont(ofSize: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    private func buildAuthContentView() -> some View {
        Button(
            action: {
                viewModel.action.send()
            },
            label: {
                HStack(spacing: 12) {
                    ImageAssets.icGoogle.swiftUIImage
                        .frame(width: 36, height: 36)
                        .scaleEffect(1.2)
                        .scaledToFill()
                        .cornerRadius(20)
                    Text("Connect with Google")
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(ColorAssets.primaryGreen200.swiftUIColor)
                .cornerRadius(8)
            }
        )
    }
}

// MARK: - GoogleAuthView_Previews

struct GoogleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuthView(viewModel: GoogleAuthViewModel())
    }
}
