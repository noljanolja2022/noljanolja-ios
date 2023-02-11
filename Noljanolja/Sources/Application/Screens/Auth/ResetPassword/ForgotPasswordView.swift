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
                isEnabled: $viewModel.isButtonEnabled
            )
        }
        .padding(16)
        .navigationBarTitle(
            Text(L10n.Auth.ForgotPassword.title),
            displayMode: .inline
        )
        .navigationBarHidden(false)
        .alert(item: $viewModel.alertType, content: { type in
            Alert(
                title: Text(type.title),
                message: Text(type.message),
                dismissButton: Alert.Button.default(
                    Text(type.actionTitle),
                    action: {
//                        TODO: Update
//                        switch type {
//                        case .success: isShowingForgotPasswordView = false
//                        case .error: isShowingForgotPasswordView = false
//                        }
                    }
                )
            )
        })
    }
}

// MARK: - ForgotPasswordView_Previews

struct ForgotPasswordView_Previews: PreviewProvider {
    @State private static var isShowingForgotPasswordView = true

    static var previews: some View {
        ForgotPasswordView(isShowingForgotPasswordView: $isShowingForgotPasswordView)
    }
}
