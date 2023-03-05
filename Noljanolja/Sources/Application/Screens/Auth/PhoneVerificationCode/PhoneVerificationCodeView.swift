//
//  PhoneVerificationCodeView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import SwiftUI

// MARK: - PhoneVerificationCodeView

struct PhoneVerificationCodeView<ViewModel: PhoneVerificationCodeViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var progressHUBState: ProgressHUBState

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            content
            Spacer()
            action
                .padding(16)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Verification")
                    .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
            }
        }
        .onChange(of: viewModel.state.isProgressHUDShowing) {
            progressHUBState.isLoading = $0
        }
        .alert(item: $viewModel.state.alertState) { Alert($0) { _ in } }
    }

    var content: some View {
        VStack(spacing: 16) {
            Text("We've sent a text message with your verification code to \(viewModel.state.fullPhoneNumber)")
                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            CodeView(text: $viewModel.state.verificationCode) {
                viewModel.send(.verifyCode)
            }
            HStack {
                Spacer()
                if viewModel.state.countdownResendCodeTime != 0 {
                    Text("Resend code in \(viewModel.state.countdownResendCodeTime) seconds")
                } else {
                    Button("Resend code") {
                        viewModel.send(.resendCode)
                    }
                }
            }
            .font(FontFamily.NotoSans.medium.swiftUIFont(size: 14))
            .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
        }
        .padding(16)
    }

    private var action: some View {
        Button(
            L10n.Common.previous,
            action: { presentationMode.wrappedValue.dismiss() }
        )
        .buttonStyle(ThridyButtonStyle())
        .shadow(
            color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
        )
    }
}

// MARK: - PhoneVerificationCodeView_Previews

struct PhoneVerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneVerificationCodeView(
            viewModel: PhoneVerificationCodeViewModel(
                state: PhoneVerificationCodeViewModel.State(
                    country: .default,
                    phoneNumber: "12345678"
                ),
                verificationID: ""
            )
        )
    }
}
