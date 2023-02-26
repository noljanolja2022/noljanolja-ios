//
//  AuthWithPhoneView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import SwiftUI
import SwiftUINavigation

// MARK: - AuthWithPhoneView

struct AuthWithPhoneView<ViewModel: AuthWithPhoneViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    init(viewModel: ViewModel = AuthWithPhoneViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            content
            NavigationLink(
                unwrapping: $viewModel.verificationID,
                onNavigate: { _ in },
                destination: { verificationID in
                    PhoneVerificationCodeView(
                        viewModel: PhoneVerificationCodeViewModel(
                            phoneNumber: viewModel.phoneNumber,
                            country: viewModel.country,
                            verificationID: verificationID.wrappedValue
                        )
                    )
                },
                label: { EmptyView() }
            )
        }
        .onReceive(viewModel.isShowingProgressHUDPublisher) {
            progressHUBState.isLoading = $0
        }
        .fullScreenCover(isPresented: $viewModel.isShowingSelectPhoneNumbers) {
            SelectCountryView(
                viewModel: SelectCountryViewModel(
                    delegate: viewModel,
                    selectedCountry: viewModel.country
                )
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
                signInWithPhone
                signInWithSNSContent
            }
            .padding(16)
        }
    }

    private var signInWithPhone: some View {
        VStack(spacing: 32) {
            Text("What's the phone number for this device?")
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
            HStack(spacing: 12) {
                Button(
                    action: {
                        viewModel.isShowingSelectPhoneNumbers = true
                    },
                    label: {
                        VStack(spacing: 4) {
                            Text("Contry")
                                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                                .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                            Text(viewModel.country.name)
                                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                                .frame(height: 32)
                        }
                        .frame(minWidth: 96, maxHeight: .infinity)
                        .padding(12)
                        .background(ColorAssets.gray.swiftUIColor)
                        .cornerRadius(12)
                    }
                )
                VStack(alignment: .leading, spacing: 4) {
                    Text("Phone Number")
                        .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                        .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                    HStack(spacing: 4) {
                        Text("+\(viewModel.country.phoneCode)")
                            .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                        TextField("", text: $viewModel.phoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(FullSizeTappableTextFieldStyle())
                            .frame(height: 32)
                    }
                    .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                }
                .padding(12)
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(12)
                .overlayBorder(
                    color: viewModel.phoneNumberErrorMessage == nil
                        ? Color.clear
                        : ColorAssets.red.swiftUIColor
                )
                .errorMessage($viewModel.phoneNumberErrorMessage)
            }

            Button(
                L10n.Auth.SignIn.title,
                action: {
                    viewModel.sendPhoneVerificationCodeTrigger.send(viewModel.phoneNumber)
                }
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

            Button(
                action: {
                    viewModel.signInWithGoogleTrigger.send()
                },
                label: {
                    ImageAssets.icGoogle.swiftUIImage.resizable()
                }
            )
            .frame(width: 42, height: 42)
            .cornerRadius(21)
        }
    }
}

// MARK: - AuthWithPhoneView_Previews

struct AuthWithPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        AuthNavigationView()
    }
}
