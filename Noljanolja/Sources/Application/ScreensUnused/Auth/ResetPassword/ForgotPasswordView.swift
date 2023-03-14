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
    // MARK: Dependencies

    @StateObject private var viewModel: ResetPasswordViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    init(viewModel: ResetPasswordViewModel = ResetPasswordViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isSuccess {
                success
            } else {
                content
            }
        }
        .onReceive(viewModel.isShowingProgressHUDPublisher) {
            progressHUBState.isLoading = $0
        }
        .navigationBarTitle(
            Text(L10n.Auth.ForgotPassword.title),
            displayMode: .inline
        )
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
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
                    action: { presentationMode.wrappedValue.dismiss() }
                )
                .buttonStyle(PrimaryButtonStyle())
                .shadow(
                    color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
                )
                
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
                .textFieldStyle(TappableTextFieldStyle())
                .setAuthTextFieldStyle()
                .overlayBorder(
                    color: viewModel.emailErrorMessage == nil
                        ? Color.clear
                        : ColorAssets.red.swiftUIColor
                )
                .errorMessage($viewModel.emailErrorMessage)
            Spacer()
            actions
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

    private var actions: some View {
        HStack(spacing: 12) {
            Button(
                L10n.Common.previous,
                action: { presentationMode.wrappedValue.dismiss() }
            )
            .buttonStyle(ThridyButtonStyle())
            .frame(width: 100)
            .shadow(
                color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
            )

            Button(
                L10n.Auth.ResetPassword.title,
                action: {
                    viewModel.resetPasswordTrigger.send(viewModel.email)
                }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isResetButtonEnabled))
            .disabled(!viewModel.isResetButtonEnabled).shadow(
                color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
            )
        }
        .padding(16)
    }
}

// MARK: - ResetPasswordView_Previews

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
