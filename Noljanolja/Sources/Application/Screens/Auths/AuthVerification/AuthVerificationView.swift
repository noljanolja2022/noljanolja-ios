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

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    @State private var isFocused = false

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .hideNavigationBar()
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildMainView()
            Spacer()
            buildActionView()
        }
    }

    private func buildMainView() -> some View {
        VStack(spacing: 36) {
            VStack(spacing: 16) {
                Text("Enter verification code")
                    .font(.system(size: 24))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text("We’ve sent a text message with your verification code to  \(viewModel.phoneNumber.formatPhone() ?? "")")
                    .font(.system(size: 16))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 24) {
                CodeView(
                    text: $viewModel.verificationCode,
                    isFocused: $isFocused,
                    action: {
                        viewModel.verifyAction.send()
                    }
                )
                ZStack {
                    if viewModel.countdownResendCodeTime != 0 {
                        Text("Resend code in \(viewModel.countdownResendCodeTime) seconds")
                            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    } else {
                        Button("Resend code") {
                            viewModel.resendCodeAction.send(
                                (viewModel.country.phoneCode, viewModel.phoneNumberText)
                            )
                        }
                        .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
                    }
                }
                .font(.system(size: 12))
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
        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2)
        .padding(16)
    }
}

// MARK: - AuthVerificationView_Previews

struct AuthVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthVerificationView(
            viewModel: AuthVerificationViewModel(
                country: CountryAPI().getDefaultCountry(),
                phoneNumberText: "123456789",
                verificationID: ""
            )
        )
    }
}
