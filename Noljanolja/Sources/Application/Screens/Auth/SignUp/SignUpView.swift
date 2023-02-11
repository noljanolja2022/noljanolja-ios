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

    @Binding var isShowingSignUpView: Bool

    init(viewModel: SignUpViewModel = SignUpViewModel(),
         isShowingSignUpView: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isShowingSignUpView = isShowingSignUpView
    }

    var body: some View {
        VStack(spacing: 0) {
            signUp
            actions
        }
        .alert(isPresented: $viewModel.isAlertMessagePresented) {
            Alert(
                title: Text(L10n.Common.Error.title),
                message: Text(viewModel.alertMessage),
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

    private var actions: some View {
        HStack(spacing: 12) {
            PrimaryButton(
                title: L10n.Common.previous,
                action: { isShowingSignUpView = false },
                isEnabled: Binding<Bool>(get: { true }, set: { _ in }),
                enabledBackgroundColor: ColorAssets.black.swiftUIColor
            )
            .frame(width: 128)
            PrimaryButton(
                title: L10n.Auth.SignUp.title,
                action: {
                    viewModel.signUpTrigger.send(
                        (viewModel.email, viewModel.password)
                    )
                },
                isEnabled: $viewModel.isSignUpButtonEnabled
            )
        }
        .padding(16)
    }
}

// MARK: - SignUpView_Previews

struct SignUpView_Previews: PreviewProvider {
    @State private static var isShowingSignUpView = true

    static var previews: some View {
        SignUpView(isShowingSignUpView: $isShowingSignUpView)
    }
}
