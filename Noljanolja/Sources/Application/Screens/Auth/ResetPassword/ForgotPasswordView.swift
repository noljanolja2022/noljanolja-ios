//
//  ForgotPasswordView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import SwiftUI

// MARK: - ForgotPasswordView

struct ForgotPasswordView: View {
    @StateObject private var viewModel: ForgotPasswordViewModel

    @Binding private var isShowingForgotPasswordView: Bool

    init(viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel(),
         isShowingForgotPasswordView: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isShowingForgotPasswordView = isShowingForgotPasswordView
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isSuccess {
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
        VStack(spacing: 24) {
            Text(L10n.Auth.ResetPassword.Success.title)
                .multilineTextAlignment(.center)
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))

            Text(L10n.Auth.ResetPassword.Success.description)
                .multilineTextAlignment(.center)
                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 14))

//            PrimaryButton(
//                title: L10n.Auth.SignIn.title,
//                action: { isShowingForgotPasswordView = false },
//                isEnabled: Binding<Bool>(get: { true }, set: { _ in })
//            )
        }
        .padding(16)
    }

    private var content: some View {
        VStack(spacing: 0) {
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
            Spacer()
            PrimaryButton(
                title: L10n.Auth.ResetPassword.title,
                action: { viewModel.resetPasswordTrigger.send(viewModel.email) },
                isEnabled: $viewModel.isResetButtonEnabled
            )
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

// MARK: - ForgotPasswordView_Previews

struct ForgotPasswordView_Previews: PreviewProvider {
    @State private static var isShowingForgotPasswordView = true

    static var previews: some View {
        ForgotPasswordView(isShowingForgotPasswordView: $isShowingForgotPasswordView)
    }
}
