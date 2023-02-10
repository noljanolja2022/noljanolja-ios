//
//  SignUpView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//
//

import SwiftUI

// MARK: - SignUpView

struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    init(viewModel: SignUpViewModel = SignUpViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 12) {
            signUp
            PrimaryButton(
                title: L10n.Auth.SignUp.title,
                action: {
                    viewModel.signUpTrigger.send(
                        (viewModel.email, viewModel.password)
                    )
                },
                isEnabled: $viewModel.isSignUpButtonEnabled
            )
            .padding(.horizontal, 16)
        }
        .alert(isPresented: $viewModel.isAlertMessagePresented) {
            Alert(
                title: Text(L10n.Common.Error.title),
                message: Text(viewModel.errorAlertMessage),
                dismissButton: .default(Text(L10n.Common.ok))
            )
        }
        .navigationBarHidden(true)
    }

    private var signUp: some View {
        ScrollView {
            VStack(spacing: 16) {
                CustomTextField(
                    placeholder: L10n.Auth.Email.placeholder,
                    text: $viewModel.email,
                    font: FontFamily.NotoSans.medium.font(size: 16),
                    contentInset: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
                )
                .frame(height: 50)
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(8)
                .shadow(
                    color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
                )

                CustomTextField(
                    placeholder: L10n.Auth.Password.placeholder,
                    text: $viewModel.password,
                    font: FontFamily.NotoSans.medium.font(size: 16),
                    isSecureTextEntry: true,
                    contentInset: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
                )
                .frame(height: 50)
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(8)
                .shadow(
                    color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
                )

                CustomTextField(
                    placeholder: L10n.Auth.ConfirmPassword.placeholder,
                    text: $viewModel.confirmPassword,
                    font: FontFamily.NotoSans.medium.font(size: 16),
                    isSecureTextEntry: true,
                    contentInset: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
                )
                .frame(height: 50)
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(8)
                .shadow(
                    color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
                )
            }
            .padding(16)
        }
        .introspectScrollView { scrollView in
            scrollView.alwaysBounceVertical = false
        }
    }
}

// MARK: - SignUpView_Previews

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
