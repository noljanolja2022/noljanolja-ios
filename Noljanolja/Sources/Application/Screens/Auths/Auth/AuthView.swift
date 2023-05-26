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

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLink()
        }
        .hideNavigationBar()
        .onChange(of: viewModel.isProgressHUDShowing) {
            progressHUBState.isLoading = $0
        }
        .alert(item: $viewModel.alertState) {
            Alert($0) { action in
                guard let action, action else { return }
                viewModel.sendVerificationCodeAction.send(
                    (viewModel.country.phoneCode, viewModel.phoneNumber?.formatPhone())
                )
            }
        }
        .fullScreenCover(
            unwrapping: $viewModel.fullScreenCoverType,
            content: {
                buildFullScreenCoverDestinationView($0)
            }
        )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()
            buildAuthView()
        }
        .background(
            ColorAssets.primaryGreen100.swiftUIColor
                .ignoresSafeArea(edges: .top)
        )
    }

    private func buildHeaderView() -> some View {
        ImageAssets.logo.swiftUIImage
            .resizable()
            .scaledToFill()
            .frame(width: 126, height: 114)
            .padding(32)
    }

    private func buildAuthView() -> some View {
        VStack(spacing: 8) {
            ScrollView {
                VStack(spacing: 24) {
                    buildAuthHeaderView()
                    buildPhoneView()
                }
                .padding(.horizontal, 16)
                .padding(.top, 28)
            }
            buildActionView()
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius([.topLeading, .topTrailing], 40)
    }

    private func buildAuthHeaderView() -> some View {
        VStack(spacing: 4) {
            Text(L10n.Common.login)
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            Text(L10n.Login.Phone.description)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    private func buildPhoneView() -> some View {
        HStack(spacing: 12) {
            Button(
                action: {
                    viewModel.fullScreenCoverType = .selectCountry
                },
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
                guard let title = viewModel.phoneNumber?.formatPhone(type: .international) else {
                    return
                }
                viewModel.alertState = AlertState(
                    title: TextState(title),
                    message: TextState("You will receive a code to verify to this phone number via text message."),
                    primaryButton: .destructive(TextState("Cancel")),
                    secondaryButton: .default(TextState("Confirm"), action: .send(true))
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
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    private func buildNavigationLink() -> some View {
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
        .isDetailLink(false)
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<AuthFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .selectCountry:
            NavigationView {
                SelectCountryView(
                    viewModel: SelectCountryViewModel(
                        selectedCountry: viewModel.country,
                        delegate: viewModel
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// MARK: - AuthView_Previews

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AuthView(viewModel: AuthViewModel())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
