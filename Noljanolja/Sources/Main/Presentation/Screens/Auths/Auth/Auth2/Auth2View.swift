//
//  Auth2View.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/10/2023.
//
//

import SwiftUI

// MARK: - Auth2View

struct Auth2View<ViewModel: Auth2ViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    
    // MARK: State
    
    @State private var email = ""
    @State private var password = ""

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
            Text(L10n.loginGoogleDescription)
                .dynamicFont(.systemFont(ofSize: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    private func buildAuthContentView() -> some View {
        VStack(spacing: 16) {
            buildEmailPasswordLoginView()
            buildOtherLoginView()
        }
    }
    
    @ViewBuilder
    private func buildEmailPasswordLoginView() -> some View {
        if viewModel.remoteConfigModel.isLoginEmailPasswordEnabled {
            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .font(Font.system(size: 16))
                    .frame(height: 48)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                SecureField("Password", text: $password)
                    .font(Font.system(size: 16))
                    .frame(height: 48)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Button(
                    action: {
                        viewModel.signInWithEmailPasswordAction.send((email, password))
                    },
                    label: {
                        Text("Sign In")
                            .font(Font.system(size: 16).bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                .frame(height: 48)
                .background(ColorAssets.primaryGreen200.swiftUIColor)
                .cornerRadius(8)
                .padding(.vertical, 4)
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .overlay(Color.gray)
                        .padding(8)
                    Text("OR")
                        .font(Font.system(size: 16))
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1)
                        .overlay(Color.gray)
                        .padding(8)
                }
                .padding(.vertical, 12)
            }
        }
    }
    
    private func buildOtherLoginView() -> some View {
        VStack(spacing: 16) {
            Button(
                action: {
                    viewModel.googleSignInAction.send()
                },
                label: {
                    HStack(spacing: 12) {
                        ImageAssets.icGoogle.swiftUIImage
                            .frame(width: 36, height: 36)
                            .scaleEffect(1.2)
                            .scaledToFill()
                            .cornerRadius(20)
                        Text(L10n.loginGoogleButton)
                            .dynamicFont(.systemFont(ofSize: 19, weight: .medium))
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(ColorAssets.primaryGreen200.swiftUIColor)
                    .cornerRadius(8)
                }
            )
                
            if viewModel.remoteConfigModel.isLoginAppleEnabled {
                Button(
                    action: {
                        viewModel.appleSignInAction.send()
                    },
                    label: {
                        HStack(spacing: 12) {
                            ImageAssets.icApple.swiftUIImage
                                .frame(width: 36, height: 36)
                                .scaleEffect(1.2)
                                .scaledToFill()
                                .cornerRadius(20)
                            Text(L10n.loginAppleButton)
                                .dynamicFont(.systemFont(ofSize: 19, weight: .medium))
                                .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .cornerRadius(8)
                    }
                )
            }
        }
    }
}

// MARK: - Auth2View_Previews

struct Auth2View_Previews: PreviewProvider {
    static var previews: some View {
        Auth2View(viewModel: Auth2ViewModel())
    }
}
