//
//  ProfileView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Kingfisher
import SDWebImageSwiftUI
import SwiftUI

// MARK: - ProfileView

struct ProfileView<ViewModel: ProfileViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 8) {
            buildHeader()
            buildMainView()
            buildLogOutView()
        }
        .background(ColorAssets.primaryMain.swiftUIColor)
    }

    private func buildHeader() -> some View {
        HStack(spacing: 24) {
            WebImage(url: URL(string: viewModel.user?.avatar))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 64, height: 64)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(32)

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.user?.name ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                HStack(spacing: 8) {
                    ImageAssets.icKing.swiftUIImage
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                    Text("Gold Membership")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                }
                .frame(height: 28)
                .padding(.horizontal, 8)
                .background(ColorAssets.neutralDarkGrey.swiftUIColor)
                .cornerRadius(14)

                Text("Friends: 24")
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }

            VStack(spacing: 0) {
                Button(
                    action: {
                        viewModel.navigationType = .setting
                    },
                    label: {
                        ImageAssets.icSetting.swiftUIImage
                            .frame(width: 24, height: 24)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorAssets.white.swiftUIColor)
        .cornerRadius([.bottomLeading, .bottomTrailing], 24)
    }

    private func buildMainView() -> some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("My Point")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    HStack(spacing: 12) {
                        ImageAssets.icPoint.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        Text("982,350")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .aspectRatio(CGSize(width: 3, height: 1), contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                        .stroke(Color.yellow, style: StrokeStyle(lineWidth: 2, dash: [8]))
                )

                HStack(spacing: 12) {
                    VStack(spacing: 12) {
                        ImageAssets.icPointAccumulated.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .padding(.bottom, 8)
                        Text("Accumulated\npoints for the day")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                        Text("14,000 P")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(hexadecimal: "623B00"))
                        Button(
                            action: {},
                            label: {
                                Text("View History".uppercased())
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                                    .background(ColorAssets.primaryMain.swiftUIColor)
                                    .cornerRadius(4)
                            }
                        )
                        .padding(.top, 12)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)
                    .background(ColorAssets.white.swiftUIColor)
                    .cornerRadius(12)

                    VStack(spacing: 12) {
                        ImageAssets.icPointReload.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .padding(.bottom, 8)
                        Text("Points that\ncan be exchanged")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                        Text("8,500 P")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(hexadecimal: "007AFF"))
                        Button(
                            action: {},
                            label: {
                                Text("Exchange money".uppercased())
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 8)
                                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                                    .background(ColorAssets.primaryMain.swiftUIColor)
                                    .cornerRadius(4)
                            }
                        )
                        .padding(.top, 12)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)
                    .background(ColorAssets.white.swiftUIColor)
                    .cornerRadius(12)
                }

                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
        }
    }

    private func buildLogOutView() -> some View {
        Button(
            action: {
                viewModel.signOutAction.send()
            },
            label: {
                Text("LOG OUT")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(12)
                    .foregroundColor(ColorAssets.primaryDark.swiftUIColor)
                    .background(ColorAssets.white.swiftUIColor)
                    .cornerRadius(4)
            }
        )
        .frame(height: 48)
        .padding(16)
    }

    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: {
                buildNavigationLinkDestinationView($0)
            },
            label: {
                EmptyView()
            }
        )
    }

    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<ProfileNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .setting:
            SettingView(
                viewModel: SettingViewModel()
            )
        }
    }
}

// MARK: - ProfileView_Previews

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            viewModel: ProfileViewModel()
        )
    }
}
