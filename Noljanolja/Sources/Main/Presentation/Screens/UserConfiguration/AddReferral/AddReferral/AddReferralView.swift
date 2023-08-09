//
//  AddReferralView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/08/2023.
//
//

import SwiftUI

// MARK: - AddReferralView

struct AddReferralView<ViewModel: AddReferralViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .hideNavigationBar()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) {
                Alert($0) { _ in }
            }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildMainView() -> some View {
        ScrollView {
            VStack(spacing: 36) {
                buildHeaderView()
                buildInputView()
                buildButtonsView()
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
    }

    private func buildHeaderView() -> some View {
        ImageAssets.logo.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(width: 168, height: 168)
    }

    private func buildInputView() -> some View {
        VStack(spacing: 8) {
            Text("Referral code")
                .dynamicFont(.systemFont(ofSize: 32, weight: .bold))
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            Text("Please enter referral code to get bonus gifts.")
                .dynamicFont(.systemFont(ofSize: 14))
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            TextField(text: $viewModel.referralCode)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 48)
                .padding(.horizontal, 12)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(4)
        }
    }

    private func buildButtonsView() -> some View {
        HStack(spacing: 12) {
            Button(
                L10n.commonSkip.uppercased(),
                action: {
                    viewModel.skipAction.send(())
                }
            )
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .cornerRadius(4)
            .border(ColorAssets.primaryGreen200.swiftUIColor, width: 1, cornerRadius: 4)
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            Button(
                L10n.commonOk.uppercased(),
                action: {
                    viewModel.action.send(())
                }
            )
            .disabled(viewModel.referralCode.isEmpty)
            .buttonStyle(PrimaryButtonStyle(isEnabled: !viewModel.referralCode.isEmpty))
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .frame(maxWidth: .infinity)
        }
    }
}

extension AddReferralView {
    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<AddReferralFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .successAlert(model):
            BottomSheet {
                AddReferralAlertView(
                    viewModel: AddReferralAlertViewModel(
                        rewardPoints: model,
                        delegate: viewModel
                    )
                )
            }
        }
    }
}

// MARK: - AddReferralView_Previews

struct AddReferralView_Previews: PreviewProvider {
    static var previews: some View {
        AddReferralView(viewModel: AddReferralViewModel())
    }
}
