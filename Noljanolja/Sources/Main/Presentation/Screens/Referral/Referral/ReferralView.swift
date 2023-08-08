//
//  ReferralView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/08/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ReferralView

struct ReferralView<ViewModel: ReferralViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("")
                        .lineLimit(1)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildMainView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.currentUser == nil },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    private func buildContentView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                buildBannerImageView()
                buildReferralView()
                buildIntroView()
            }
        }
        .background(ColorAssets.secondaryYellow50.swiftUIColor.ignoresSafeArea())
    }

    private func buildBannerImageView() -> some View {
        ImageAssets.bnReferral.swiftUIImage
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .aspectRatio(9 / 5, contentMode: .fill)
    }

    private func buildReferralView() -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 0) {
                Text(viewModel.currentUser?.referralCode ?? "")
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, 32)

                Button(
                    action: {
                        guard let referralCode = viewModel.currentUser?.referralCode else { return }
                        UIPasteboard.general.string = referralCode
                    },
                    label: {
                        Text("Copy")
                            .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal, 32)
                            .background(ColorAssets.primaryGreen200.swiftUIColor)
                    }
                )
            }
            .frame(height: 52)
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius(8)
            .shadow(
                color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )

            Button(
                "Send invitation link",
                action: {
                    withoutAnimation {
                        viewModel.fullScreenCoverType = .share
                    }
                }
            )
            .buttonStyle(PrimaryButtonStyle())
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .padding(.horizontal, 16)
        }
        .padding(.top, -26)
    }

    private func buildIntroView() -> some View {
        VStack(spacing: 24) {
            Text("How to refer a friend")
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))

            LazyVGrid(columns: Array(repeating: .flexible(spacing: 16), count: 2), spacing: 16) {
                ReferralItemView(
                    model: ReferralItemViewModel(
                        imageName: ImageAssets.icReferral1.name,
                        title: "01",
                        description: "Send invitation link Just tap the button!"
                    )
                )
                ReferralItemView(
                    model: ReferralItemViewModel(
                        imageName: ImageAssets.icReferral2.name,
                        title: "02",
                        description: "Invite link to friend will be sent"
                    )
                )
                ReferralItemView(
                    model: ReferralItemViewModel(
                        imageName: ImageAssets.icReferral3.name,
                        title: "03",
                        description: "Via the link sent to you Proceed to membership registration"
                    )
                )
                ReferralItemView(
                    model: ReferralItemViewModel(
                        imageName: ImageAssets.icReferral4.name,
                        title: "04",
                        description: "When all courses are completed Friends and I also earn 1,000P!"
                    )
                )
            }

            Text("* Even if a friend manually enters the referral code after copying and sending it You can participate in the friend referral event.")
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(ColorAssets.neutralDeeperGrey.swiftUIColor)
        }
        .padding(16)
    }
}

extension ReferralView {
    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ReferralFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .share:
            ShareReferralContainerView(
                viewModel: ShareReferralContainerViewModel(
                    code: viewModel.currentUser?.referralCode
                )
            )
        }
    }
}

extension ReferralView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildErrorView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

// MARK: - ReferralView_Previews

struct ReferralView_Previews: PreviewProvider {
    static var previews: some View {
        ReferralView(viewModel: ReferralViewModel())
    }
}
