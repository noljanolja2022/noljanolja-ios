//
//  SignUpView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//
//

import SwiftUI

// MARK: - SignUpView

struct SignUpView<ViewModel: SignUpViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    init(viewModel: ViewModel = SignUpViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                signUp
                actions
            }
            NavigationLink(
                isActive: $viewModel.isShowingEmailVerificationView,
                destination: {
                    EmailVerificationView(
                        viewModel: EmailVerificationViewModel(delegate: viewModel)
                    )
                    .navigationBarHidden(true)
                },
                label: { EmptyView() }
            )
        }
        .onReceive(viewModel.isProgressHUDShowingPublisher) {
            progressHUBState.isLoading = $0
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

                SecureField(L10n.Auth.Password.placeholder, text: $viewModel.password)
                    .textFieldStyle(FullSizeTappableTextFieldStyle())
                    .textFieldStyle(AuthTextFieldStyle())
                    .setAuthTextFieldStyle()
                    .overlayBorder(
                        color: viewModel.passwordErrorMessage == nil
                            ? Color.clear
                            : ColorAssets.red.swiftUIColor
                    )
                    .errorMessage($viewModel.passwordErrorMessage)

                SecureField(L10n.Auth.ConfirmPassword.placeholder, text: $viewModel.confirmPassword)
                    .textFieldStyle(FullSizeTappableTextFieldStyle())
                    .textFieldStyle(AuthTextFieldStyle())
                    .setAuthTextFieldStyle()
                    .overlayBorder(
                        color: viewModel.confirmPasswordErrorMessage == nil
                            ? Color.clear
                            : ColorAssets.red.swiftUIColor
                    )
                    .errorMessage($viewModel.confirmPasswordErrorMessage)
            }
            .padding(16)
        }
        .introspectScrollView { scrollView in
            scrollView.alwaysBounceVertical = false
        }
        .onAppear {
            viewModel.updateSignUpStepTrigger.send(.second)
        }
    }

    private var actions: some View {
        HStack(spacing: 12) {
            Button(
                L10n.Common.previous,
                action: { presentationMode.wrappedValue.dismiss() }
            )
            .frame(width: 100)
            .buttonStyle(ThridyButtonStyle())

            Button(
                L10n.Auth.SignUp.title,
                action: { viewModel.signUpTrigger.send((viewModel.email, viewModel.password)) }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isSignUpButtonEnabled))
            .disabled(!viewModel.isSignUpButtonEnabled)
        }
        .padding(16)
    }
}

// MARK: - SignUpView_Previews

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
