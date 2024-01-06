//
//  FriendDetailView.swift
//  Noljanolja
//
//  Created by duydinhv on 15/11/2023.
//

import AlertToast
import SDWebImageSwiftUI
import SwiftUI

// MARK: - FriendDetailView

struct FriendDetailView<ViewModel: FriendDetailViewModel>: View {
    @StateObject var viewModel: ViewModel

    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var themeManager: AppThemeManager

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .top) {
            buildContentView()
            buildNavigationLink()
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .isProgressHUBVisible($viewModel.isProgressHUDShowing)
        .navigationBar(
            backButtonTitle: "",
            presentationMode: presentationMode,
            middle: {},
            trailing: {},
            backgroundColor: themeManager.theme.primary200
        )
        .toast(isPresenting: $viewModel.sendRequestSuccess, duration: 1) {
            AlertToast(
                displayMode: .hud,
                type: .systemImage("checkmark", ColorAssets.systemGreen.swiftUIColor),
                title: viewModel.typeSuccess?.successAlert,
                style: .style(
                    backgroundColor: ColorAssets.neutralDarkGrey.swiftUIColor,
                    titleColor: ColorAssets.neutralLight.swiftUIColor
                )
            )
        }
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        VStack(spacing: 20) {
            Group {
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
                    .padding(.horizontal, 16)

                    Text(viewModel.user.name ?? "")
                        .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .padding(.horizontal, 16)

                    if let requestPoints = viewModel.contactDetail?.userTransferPoint?.points {
                        Group {
                            Text(viewModel.user.name ?? "")
                                .bold()
                                + Text(" Requests you total: ")
                                + Text("\(requestPoints)")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .dynamicFont(.systemFont(ofSize: 12))
                        .padding(6)
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .background(ColorAssets.lightBlue.swiftUIColor)
                    }
                }
            }
            buildActionView()

            Spacer()
        }
        .padding(.top, 12)
        .background(ColorAssets.neutralLight.swiftUIColor)
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
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func buildActionView() -> some View {
        HStack(spacing: 12) {
            Text(L10n.requestPoint)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(12)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.secondaryYellow300.swiftUIColor)
                .cornerRadius(5, style: .circular)
                .onPress {
                    viewModel.navigationType = .requestPoint(viewModel.user)
                }

            Text(L10n.sendPoint)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(12)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.primaryGreen200.swiftUIColor)
                .cornerRadius(5, style: .circular)
                .onPress {
                    viewModel.navigationType = .sendPoint(viewModel.user)
                }
        }
        .padding(.horizontal, 16)
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
                case let .sendPoint(user):
                    SendRequestPointView(
                        viewModel: SendRequestViewModel(user: user, type: .send, delegate: viewModel)
                    )
                case let .requestPoint(user):
                    SendRequestPointView(
                        viewModel: SendRequestViewModel(user: user, type: .request, delegate: viewModel)
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
