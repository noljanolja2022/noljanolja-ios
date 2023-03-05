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

    @State private var isSelectCountryShown = false
    @EnvironmentObject private var progressHUBState: ProgressHUBState

    init(viewModel: ViewModel = AuthWithPhoneViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            content
            navigationLinks
        }
        .onChange(of: viewModel.state.isProgressHUDShowing) {
            progressHUBState.isLoading = $0
        }
        .fullScreenCover(isPresented: $isSelectCountryShown) {
            NavigationView {
                SelectCountryView(
                    viewModel: SelectCountryViewModel(
                        state: SelectCountryViewModel.State(
                            selectedCountry: viewModel.state.country
                        ),
                        delegate: viewModel
                    )
                )
            }
        }
        .alert(item: $viewModel.state.alertState) {
            Alert($0) { action in
                if let action, action {
                    viewModel.send(.sendVerificationCode)
                }
            }
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
                    action: { isSelectCountryShown = true },
                    label: {
                        VStack(spacing: 4) {
                            Text("Contry")
                                .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                                .foregroundColor(ColorAssets.forcegroundSecondary.swiftUIColor)
                            Text(viewModel.state.country.name)
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
                        Text("+\(viewModel.state.country.phoneCode)")
                            .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                        TextField("", text: $viewModel.state.phoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(FullSizeTappableTextFieldStyle())
                            .frame(height: 32)
                    }
                    .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                }
                .padding(12)
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(12)
            }

            Button(
                L10n.Auth.SignIn.title,
                action: { viewModel.send(.showConfirmPhoneAlert) }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.state.isSignInButtonEnabled))
            .disabled(!viewModel.state.isSignInButtonEnabled)
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
                action: { viewModel.send(.signInWithGoogle) },
                label: { ImageAssets.icGoogle.swiftUIImage.resizable() }
            )
            .frame(width: 42, height: 42)
            .cornerRadius(21)
        }
    }

    private var navigationLinks: some View {
        NavigationLink(
            unwrapping: $viewModel.state.verificationID,
            onNavigate: { _ in },
            destination: { verificationID in
                PhoneVerificationCodeView(
                    viewModel: PhoneVerificationCodeViewModel(
                        state: PhoneVerificationCodeViewModel.State(
                            country: viewModel.state.country,
                            phoneNumber: viewModel.state.phoneNumber
                        ),
                        verificationID: verificationID.wrappedValue,
                        delegate: viewModel
                    )
                )
            },
            label: { EmptyView() }
        )
    }
}

// MARK: - AuthWithPhoneView_Previews

struct AuthWithPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AuthWithPhoneView()
        }
    }
}
