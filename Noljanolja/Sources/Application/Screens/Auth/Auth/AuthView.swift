//
//  AuthView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import SwiftUI
import SwiftUINavigation
import SwiftUIX

// MARK: - AuthView

struct AuthView<ViewModel: AuthViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState
    @State private var isSelectCountryShown = false

    var body: some View {
        buildBodyView()
            .hideNavigationBar()
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .fullScreenCover(isPresented: $isSelectCountryShown) {
                NavigationView {
                    SelectCountryView(
                        viewModel: SelectCountryViewModel(
                            selectedCountry: viewModel.country,
                            delegate: viewModel
                        )
                    )
                }
            }
            .alert(item: $viewModel.alertState) {
                Alert($0) { action in
                    guard let action, action else { return }
                    viewModel.sendPhoneVerificationCodeSubject.send(
                        (viewModel.country.phoneCode, viewModel.phoneNumber?.formatPhone())
                    )
                }
            }
    }

    private func buildBodyView() -> some View {
        ZStack {
            VStack(spacing: 0) {
                buildHeaderView()
                buildContentView()
            }
            .background(
                ColorAssets.primaryYellowMain.swiftUIColor
                    .ignoresSafeArea(edges: .top)
            )
            buildNavigationLinks()
        }
    }

    private func buildHeaderView() -> some View {
        ImageAssets.logo.swiftUIImage
            .resizable()
            .scaledToFill()
            .frame(width: 126, height: 114)
            .padding(32)
    }

    private func buildContentView() -> some View {
        VStack {
            ScrollView {
                VStack(spacing: 32) {
                    buildContentHeaderView()
                    buildPhoneView()
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 32)
                .padding(.bottom, 16)
            }

            buildActionView()
        }
        .background(ColorAssets.white.swiftUIColor)
        .cornerRadius(40, corners: [.topLeft, .topRight])
    }

    private func buildContentHeaderView() -> some View {
        VStack(spacing: 4) {
            Text("Log in")
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Text("Welcome to Nolja Nolja. Please enter your Phone number to join continue.")
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    private func buildPhoneView() -> some View {
        HStack(spacing: 12) {
            Button(
                action: { isSelectCountryShown = true },
                label: {
                    VStack {
                        HStack(spacing: 8) {
                            Text(viewModel.country.getFlagEmoji())
                                .font(.system(size: 24))
                                .frame(width: 30, height: 24)
                                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                                .cornerRadius(3)
                            Text("+\(viewModel.country.phoneCode)")
                                .font(.system(size: 16))
                                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        }
                        .frame(maxHeight: .infinity)

                        Divider()
                            .frame(height: 1)
                            .overlay(ColorAssets.neutralGrey.swiftUIColor)
                    }
                }
            )
            .frame(width: 88)

            VStack {
                TextField("", text: $viewModel.phoneNumberText)
                    .keyboardType(.phonePad)
                    .textFieldStyle(TappableTextFieldStyle())
                    .font(.system(size: 16))
                    .frame(maxHeight: .infinity)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }

                Divider()
                    .frame(height: 1)
                    .overlay(ColorAssets.neutralGrey.swiftUIColor)
            }
            .frame(maxHeight: .infinity)
        }
        .frame(height: 36)
    }

    private func buildActionView() -> some View {
        Button(
            "Continue".uppercased(),
            action: {
                viewModel.confirmPhoneAlertSubject.send(
                    viewModel.phoneNumber?.formatPhone(type: .international)
                )
            }
        )
        .buttonStyle(
            PrimaryButtonStyle(
                isEnabled: !viewModel.phoneNumberText.isEmpty
            )
        )
        .disabled(viewModel.phoneNumberText.isEmpty)
        .frame(height: 48)
        .padding(16)
    }

    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.verificationID,
            onNavigate: { _ in },
            destination: { verificationID in
                AuthVerificationView(
                    viewModel: AuthVerificationViewModel(
                        country: viewModel.country,
                        phoneNumberText: viewModel.phoneNumberText,
                        verificationID: verificationID.wrappedValue,
                        delegate: viewModel
                    )
                )
            },
            label: { EmptyView() }
        )
    }
}

// MARK: - AuthView_Previews

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AuthView(viewModel: AuthViewModel())
        }
    }
}
