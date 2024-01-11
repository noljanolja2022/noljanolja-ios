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
            .navigationBar(
                title: L10n.joinPlay,
                backButtonTitle: "",
                presentationMode: presentationMode,
                trailing: {},
                backgroundColor: ColorAssets.primaryGreen200.swiftUIColor
            )
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
        ZStack {
            buildContentView()
                .statefull(
                    state: $viewModel.viewState,
                    isEmpty: { viewModel.currentUser == nil },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
            buildNavigationLink()
        }
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
                        Text(L10n.commonCopy)
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
                L10n.sendInviteLink,
                action: {
                    withoutAnimation {
                        viewModel.fullScreenCoverType = .share
                    }
                }
            )
            .buttonStyle(PrimaryButtonStyle(enabledBackgroundColor: ColorAssets.primaryGreen200.swiftUIColor))
            .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
            .padding(.horizontal, 16)
        }
        .padding(.top, -26)
    }

    private func buildIntroView() -> some View {
        VStack(spacing: 24) {
            Text(L10n.howToRefer)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))

            LazyVGrid(columns: Array(repeating: .flexible(spacing: 16), count: 2), spacing: 16) {
                ReferralItemView(
                    model: ReferralItemViewModel(
                        imageName: ImageAssets.icReferral1.name,
                        title: "01",
                        description: L10n.referralStep1
                    )
                )
                ReferralItemView(
                    model: ReferralItemViewModel(
                        imageName: ImageAssets.icReferral2.name,
                        title: "02",
                        description: L10n.referralStep2
                    )
                )
                ReferralItemView(
                    model: ReferralItemViewModel(
                        imageName: ImageAssets.icReferral3.name,
                        title: "03",
                        description: L10n.referralStep3
                    )
                )
                ReferralItemView(
                    model: ReferralItemViewModel(
                        imageName: ImageAssets.icReferral4.name,
                        title: "04",
                        description: L10n.referralStep4
                    )
                )
            }

            Text(L10n.referralDescription)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(ColorAssets.neutralDeeperGrey.swiftUIColor)
        }
        .padding(16)
    }
}

extension ReferralView {
    @ViewBuilder
    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { buildNavigationDestinationView($0) },
            label: {}
        )
    }

    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<ReferralFullScreenNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .chat(conversationId):
            ChatView(
                viewModel: ChatViewModel(
                    conversationID: conversationId
                )
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ReferralFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .share:
            ShareReferralContainerView(
                viewModel: ShareReferralContainerViewModel(
                    code: viewModel.currentUser?.referralCode,
                    delegate: viewModel
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
