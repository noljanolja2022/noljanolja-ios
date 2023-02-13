//
//  SignInView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/02/2023.
//

import Introspect
import SwiftUI

// MARK: - SignInView

struct SignInView: View {
    @StateObject private var viewModel: SignInViewModel
    
    @Binding private var isShowingResetPasswordView: Bool
    
    init(viewModel: SignInViewModel = SignInViewModel(),
         isShowingResetPasswordView: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isShowingResetPasswordView = isShowingResetPasswordView
    }
    
    var body: some View {
        ZStack {
            content
            NavigationLink(
                isActive: $viewModel.isShowingEmailVerificationView,
                destination: {
                    EmailVerificationView(
                        viewModel: EmailVerificationViewModel(signUpStep: .constant(.third)),
                        isShowingEmailVerificationView: $viewModel.isShowingEmailVerificationView
                    )
                    .navigationBarTitle(
                        Text("Email verification"),
                        displayMode: .inline
                    )
                    .navigationBarHidden(false)
                },
                label: { EmptyView() }
            )
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
        .introspectScrollView { scrollView in
            scrollView.alwaysBounceVertical = false
        }
    }
    
    private var signInWithEmailPasswordContent: some View {
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
            
            HStack {
                Spacer()
                Button(
                    action: { isShowingResetPasswordView = true },
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
                action: {
                    viewModel.signInWithEmailPasswordTrigger.send(
                        (viewModel.email, viewModel.password)
                    )
                }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isSignInButtonEnabled))
            .disabled(!viewModel.isSignInButtonEnabled)
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
    @State private static var isShowingResetPasswordView = false
    static var previews: some View {
        SignInView(isShowingResetPasswordView: $isShowingResetPasswordView)
    }
}

// MARK: - CustomButtonStyle

protocol CustomButtonStyle: ButtonStyle {
    var isEnabled: Bool { get }
    var enabledForegroundColor: Color { get }
    var disabledForegroundColor: Color { get }
    var enabledBackgroundColor: Color { get }
    var disabledBackgroundColor: Color { get }
    var enabledBorderColor: Color { get }
    var disabledBorderColor: Color { get }
}

extension CustomButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let foregroundColor: Color = {
            let enabledForegroundColor = isEnabled ? enabledForegroundColor : disabledForegroundColor
            let foregroundColor = configuration.isPressed ? enabledForegroundColor.opacity(0.5) : enabledForegroundColor
            return foregroundColor
        }()
        
        let borderColor: Color = {
            let enabledBorderColor = isEnabled ? enabledBorderColor : disabledBorderColor
            let borderColor = configuration.isPressed ? enabledBorderColor.opacity(0.5) : enabledBorderColor
            return borderColor
        }()

        return configuration.label
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
            .foregroundColor(foregroundColor)
            .background(
                isEnabled ? enabledBackgroundColor : disabledBackgroundColor
            )
            .cornerRadius(8)
            .overlayBorder(
                color: borderColor, lineWidth: 1
            )
            .shadow(
                color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
            )
    }
}

// MARK: - PrimaryButtonStyle

struct PrimaryButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.white.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.forcegroundSecondary.swiftUIColor
    let enabledBackgroundColor: Color = ColorAssets.highlightPrimary.swiftUIColor
    let disabledBackgroundColor: Color = ColorAssets.gray.swiftUIColor
    let enabledBorderColor = Color.clear
    let disabledBorderColor = Color.clear

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

// MARK: - SecondaryButtonStyle

struct SecondaryButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.white.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.forcegroundSecondary.swiftUIColor
    let enabledBackgroundColor: Color = ColorAssets.black.swiftUIColor
    let disabledBackgroundColor: Color = ColorAssets.gray.swiftUIColor
    let enabledBorderColor = Color.clear
    let disabledBorderColor = Color.clear

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

// MARK: - ThridyButtonStyle

struct ThridyButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.black.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.forcegroundSecondary.swiftUIColor
    let enabledBackgroundColor: Color = ColorAssets.white.swiftUIColor
    let disabledBackgroundColor: Color = ColorAssets.gray.swiftUIColor
    let enabledBorderColor: Color = ColorAssets.black.swiftUIColor
    let disabledBorderColor: Color = ColorAssets.forcegroundSecondary.swiftUIColor

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}
