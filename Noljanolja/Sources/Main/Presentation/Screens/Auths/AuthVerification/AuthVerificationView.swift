//
//  AuthVerificationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - AuthVerificationView

struct AuthVerificationView<ViewModel: AuthVerificationViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    @StateObject private var keyboard = Keyboard.main

    @State private var isFocused = false

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .hideNavigationBar()
            .onAppear {
                viewModel.isAppearSubject.send(true)
            }
            .onDisappear {
                viewModel.isAppearSubject.send(false)
            }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildMainView()
            Spacer()
            buildActionView()
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildMainView() -> some View {
        VStack(spacing: 36) {
            VStack(spacing: 16) {
                Text(L10n.otpTitle)
                    .dynamicFont(.systemFont(ofSize: 24))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text("\(L10n.otpDescription)  \(viewModel.phoneNumber.formatPhone() ?? "")")
                    .dynamicFont(.systemFont(ofSize: 16))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 24) {
                CodeView(
                    text: $viewModel.verificationCode,
                    isFocused: $isFocused,
                    action: {
                        keyboard.dismiss()
                        viewModel.verifyAction.send()
                    }
                )
                .introspectTextField { textField in
                    textField.becomeFirstResponder()
                }

                ZStack {
                    if viewModel.countdownResendCodeTime != 0 {
                        Text(L10n.otpResendCodeWaiting(viewModel.countdownResendCodeTime))
                            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    } else {
                        Button(L10n.otpResendCode) {
                            viewModel.resendCodeAction.send(
                                (viewModel.country.prefix, viewModel.phoneNumberText)
                            )
                        }
                        .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
                    }
                }
                .dynamicFont(.systemFont(ofSize: 12))
                .padding(.vertical, 8)
                .padding(.horizontal, 32)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 32)
    }

    private func buildActionView() -> some View {
        Button(
            L10n.commonPrevious,
            action: { presentationMode.wrappedValue.dismiss() }
        )
        .buttonStyle(ThridyButtonStyle())
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.15),
            radius: 2,
            x: 0,
            y: 2
        )
        .padding(16)
    }
}

// MARK: - AuthVerificationView_Previews

struct AuthVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthVerificationView(
            viewModel: AuthVerificationViewModel(
                country: CountryNetworkRepositoryImpl().getDefaultCountry(),
                phoneNumberText: "123456789",
                verificationID: ""
            )
        )
    }
}
