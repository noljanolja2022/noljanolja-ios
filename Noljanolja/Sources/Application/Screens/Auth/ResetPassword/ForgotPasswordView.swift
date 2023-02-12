//
//  ResetPasswordView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import SwiftUI

// MARK: - ResetPasswordView

struct ResetPasswordView: View {
    @StateObject private var viewModel: ResetPasswordViewModel

    @Binding private var isShowingResetPasswordView: Bool

    init(viewModel: ResetPasswordViewModel = ResetPasswordViewModel(),
         isShowingResetPasswordView: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isShowingResetPasswordView = isShowingResetPasswordView
    }

    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.isSuccess {
                success
            } else {
                content
            }
        }
        .navigationBarTitle(
            Text(L10n.Auth.ForgotPassword.title),
            displayMode: .inline
        )
        .navigationBarHidden(false)
    }

    private var success: some View {
        VStack(spacing: 36) {
            VStack(spacing: 16) {
                Text(L10n.Auth.ResetPassword.Success.title)
                    .multilineTextAlignment(.center)
                    .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                    .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                Text(L10n.Auth.ResetPassword.Success.description)
                    .multilineTextAlignment(.center)
                    .font(FontFamily.NotoSans.medium.swiftUIFont(size: 14))
                    .padding(.horizontal, 24)
                    .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
            }
            VStack(spacing: 0) {
                Button(
                    L10n.Auth.SignIn.title,
                    action: { isShowingResetPasswordView = false }
                )
                .frame(height: 48)
                .buttonStyle(PrimaryButtonStyle())
                
                Button(
                    L10n.Auth.ResetPassword.Retry.title,
                    action: {
                        viewModel.resetPasswordTrigger.send(viewModel.email)
                    }
                )
                .frame(height: 48)
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
                .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
            }
        }
        .padding(16)
    }

    private var content: some View {
        VStack(spacing: 0) {
            TextField(L10n.Auth.Email.placeholder, text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textFieldStyle(FullSizeTappableTextFieldStyle())
                .textFieldStyle(AuthTextFieldStyle())
                .setAuthTextFieldStyle()
                .overlayBorder(
                    color: viewModel.emailErrorMessage == nil
                        ? Color.clear
                        : ColorAssets.red.swiftUIColor
                )
                .errorMessage($viewModel.emailErrorMessage)
            Spacer()
            Button(
                L10n.Auth.ResetPassword.title,
                action: {
                    viewModel.resetPasswordTrigger.send(viewModel.email)
                }
            )
            .frame(height: 48)
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isResetButtonEnabled))
            .disabled(!viewModel.isResetButtonEnabled)
        }
        .padding(16)
        .alert(isPresented: $viewModel.isAlertMessagePresented) {
            Alert(
                title: Text(L10n.Common.Error.title),
                message: Text(viewModel.alertMessage),
                dismissButton: Alert.Button.default(Text(L10n.Common.ok))
            )
        }
    }
}

// MARK: - ResetPasswordView_Previews

struct ResetPasswordView_Previews: PreviewProvider {
    @State private static var isShowingResetPasswordView = true

    static var previews: some View {
        ResetPasswordView(isShowingResetPasswordView: $isShowingResetPasswordView)
    }
}
