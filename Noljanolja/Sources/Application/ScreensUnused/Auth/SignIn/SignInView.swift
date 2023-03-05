//
//  SignInView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import SwiftUI

// MARK: - SignInView

struct SignInView<ViewModel: SignInViewModelType>: View {
    // MARK: Dependencies
    
    @StateObject private var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    init(viewModel: ViewModel = SignInViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            content
            NavigationLink(
                isActive: $viewModel.isShowingEmailVerificationView,
                destination: {
                    EmailVerificationView(
                        viewModel: EmailVerificationViewModel(delegate: viewModel)
                    )
                    .navigationBarTitle(
                        Text("Email verification"),
                        displayMode: .inline
                    )
                    .navigationBarHidden(false)
                    .navigationBarBackButtonHidden(true)
                },
                label: { EmptyView() }
            )
        }
        .onReceive(viewModel.isShowingProgressHUDPublisher) {
            progressHUBState.isLoading = $0
        }
        .alert(isPresented: $viewModel.isAlertMessagePresented) {
            Alert(
                title: Text(L10n.Common.Error.title),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text(L10n.Common.ok))
            )
        }
    }
    
    private var content: some View {
        ScrollView {
            VStack(spacing: 12) {
                signInWithEmailPasswordContent
                signInWithSNSContent
            }
            .padding(16)
        }
    }
    
    private var signInWithEmailPasswordContent: some View {
        VStack(spacing: 16) {
            TextField(L10n.Auth.Email.placeholder, text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textFieldStyle(FullSizeTappableTextFieldStyle())
                .setAuthTextFieldStyle()
                .overlayBorder(
                    color: viewModel.emailErrorMessage == nil
                        ? Color.clear
                        : ColorAssets.red.swiftUIColor
                )
                .errorMessage($viewModel.emailErrorMessage)

            SecureField(L10n.Auth.Password.placeholder, text: $viewModel.password)
                .textFieldStyle(FullSizeTappableTextFieldStyle())
                .setAuthTextFieldStyle()
                .overlayBorder(
                    color: viewModel.passwordErrorMessage == nil
                        ? Color.clear
                        : ColorAssets.red.swiftUIColor
                )
                .errorMessage($viewModel.passwordErrorMessage)
            
            HStack {
                Spacer()
                Button(
                    action: { viewModel.forgotPasswordTrigger.send() },
                    label: {
                        Text(L10n.Auth.ForgotPassword.title)
                            .font(FontFamily.NotoSans.regular.swiftUIFont(size: 14))
                            .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                            .frame(height: 20)
                    }
                )
                .padding(.vertical, 16)
            }
            Button(
                L10n.Auth.SignIn.title,
                action: { viewModel.signInWithEmailPasswordTrigger.send((viewModel.email, viewModel.password)) }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isSignInButtonEnabled))
            .disabled(!viewModel.isSignInButtonEnabled)
            .shadow(
                color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
            )
        }
    }
    
    private var signInWithSNSContent: some View {
        VStack(spacing: 12) {
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .overlay(ColorAssets.forcegroundTertiary.swiftUIColor)
                Text(L10n.Auth.SignInWithSns.title)
                    .font(FontFamily.NotoSans.regular.swiftUIFont(size: 12))
                    .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                Rectangle()
                    .frame(height: 1)
                    .overlay(ColorAssets.forcegroundTertiary.swiftUIColor)
            }
            .padding(.vertical, 24)
            
            HStack(spacing: 24) {
                ForEach(0...3, id: \.self) { index in
                    Button(
                        action: {
                            switch index {
                            case 0:
                                viewModel.signInWithKakaoTrigger.send()
                            case 1:
                                viewModel.signInWithNaverTrigger.send()
                            case 2:
                                viewModel.signInWithGoogleTrigger.send()
                            case 3:
                                viewModel.signInWithAppleTrigger.send()
                            default:
                                break
                            }
                        },
                        label: {
                            switch index {
                            case 0:
                                ImageAssets.icKakao.swiftUIImage.resizable()
                            case 1:
                                ImageAssets.icNaver.swiftUIImage.resizable()
                            case 2:
                                ImageAssets.icGoogle.swiftUIImage.resizable()
                            case 3:
                                ImageAssets.icApple.swiftUIImage.resizable()
                            default:
                                EmptyView()
                            }
                        }
                    )
                    .frame(width: 42, height: 42)
                    .cornerRadius(21)
                }
            }
        }
    }
}

// MARK: - SignInView_Previews

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
