//
//  FriendDetailView.swift
//  Noljanolja
//
//  Created by duydinhv on 15/11/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - FriendDetailView

struct FriendDetailView<ViewModel: FriendDetailViewModel>: View {
    @StateObject var viewModel: ViewModel

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .top) {
            buildBackgroundView()
            buildContentView()
            buildNavigationLink()
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .isProgressHUBVisible($viewModel.isProgressHUDShowing)
    }

    @ViewBuilder
    private func buildBackgroundView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                VStack(spacing: 0) {
                    ImageAssets.bgFriendsHeader.swiftUIImage
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .scaledToFit()
                        .background(ColorAssets.primaryGreen50.swiftUIColor)
                        .edgesIgnoringSafeArea(.top)
                    ColorAssets.neutralLight.swiftUIColor
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        VStack(alignment: .leading) {
            buildHeaderView()

            VStack(spacing: 20) {
                buildPointView()
                VStack(spacing: 8) {
                    WebImage(
                        url: URL(string: viewModel.user.avatar),
                        context: [
                            .imageTransformer: SDImageResizingTransformer(
                                size: CGSize(width: 40 * 3, height: 40 * 3),
                                scaleMode: .aspectFill
                            )
                        ]
                    )
                    .resizable()
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: 174, height: 174)
                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    .cornerRadius(14)
                    Text(viewModel.user.name ?? "")
                        .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                buildActionView()
            }
            .padding(.top, 12)
            .padding(.horizontal, 16)
            .background(ColorAssets.neutralLight.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            ImageAssets.icBack.swiftUIImage
                .frame(width: 24, height: 24)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func buildPointView() -> some View {
        WalletMoneyView(
            model: WalletMoneyViewDataModel(
                title: L10n.walletMyPoint,
                titleColorName: ColorAssets.primaryGreen50.name,
                changeString: nil,
                changeColorName: ColorAssets.secondaryYellow200.name,
                iconName: ImageAssets.icPoint.name,
                valueString: viewModel.myPoint?.formatted() ?? "0",
                valueColorName: ColorAssets.secondaryYellow400.name,
                backgroundImageName: ImageAssets.bnPoint.name,
                padding: 16
            )
        )
        .frame(maxWidth: .infinity, maxHeight: 97)
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    @ViewBuilder
    private func buildActionView() -> some View {
        Label {
            Text(L10n.addFriendChatNow.uppercased())
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
        } icon: {
            ImageAssets.icChatLine.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
        .background(ColorAssets.systemBlue50.swiftUIColor)
        .cornerRadius(5, style: .circular)
        .onPress {
            viewModel.openChatWithUserAction.send(viewModel.user)
        }

        HStack(spacing: 12) {
            Text(L10n.requestPoint)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(12)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.secondaryYellow300.swiftUIColor)
                .cornerRadius(5, style: .circular)
                .onPress {}

            Text(L10n.sendPoint)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(12)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.primaryGreen200.swiftUIColor)
                .cornerRadius(5, style: .circular)
                .onPress {}
        }
    }
    
    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { item in
                switch item.wrappedValue {
                case let .chat(conversation):
                    ChatView(
                        viewModel: ChatViewModel(
                            conversationID: conversation.id,
                            delegate: viewModel
                        )
                    )
                }
            },
            label: {
                EmptyView()
            }
        )
        .isDetailLink(false)
    }
}
