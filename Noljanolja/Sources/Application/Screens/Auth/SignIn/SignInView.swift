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
    
    init(viewModel: SignInViewModel = SignInViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
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
        .alert(isPresented: $viewModel.isAlertMessagePresented) {
            Alert(
                title: Text(L10n.Common.Error.title),
                message: Text(viewModel.errorAlertMessage),
                dismissButton: .default(Text(L10n.Common.ok))
            )
        }
    }
    
    private var signInWithEmailPasswordContent: some View {
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

            HStack {
                Spacer()
                Button(
                    action: {},
                    label: {
                        Text(L10n.Auth.forgotPassword)
                            .font(FontFamily.NotoSans.regular.swiftUIFont(size: 14))
                            .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                            .frame(height: 20)
                    }
                )
                .padding(.vertical, 16)
            }

            PrimaryButton(
                title: L10n.Auth.SignIn.title,
                action: {
                    viewModel.signInWithEmailPasswordTrigger.send(
                        (viewModel.email, viewModel.password)
                    )
                },
                isEnabled: $viewModel.isSignInButtonEnabled
            )
        }
    }
    
    private var signInWithSNSContent: some View {
        VStack(spacing: 12) {
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .overlay(ColorAssets.forcegroundTertiary.swiftUIColor)
                Text(L10n.Auth.signInWithSns)
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
