//
//  HomeFriendView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/09/2023.
//
//

import SwiftUI

// MARK: - HomeFriendView

struct HomeFriendView<ViewModel: HomeFriendViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @EnvironmentObject var themeManager: AppThemeManager

    var body: some View {
        contentView()
    }

    @ViewBuilder
    private func contentView() -> some View {
        VideoDetailRootContainerView(
            content: {
                ZStack(alignment: .bottomTrailing) {
                    VStack(spacing: 16) {
                        buildHeaderView()
                        buildBodyView()
                    }
                    buildFloatButton()
                    buildNavigationLink()
                }
                .background(ColorAssets.neutralLight.swiftUIColor)
            },
            viewModel: VideoDetailRootContainerViewModel()
        )
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        HStack(spacing: 12) {
            HStack {
                Text(L10n.commonSearchFriend)
                    .dynamicFont(.systemFont(ofSize: 14))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Spacer()
                ImageAssets.icSearch.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .height(24)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .frame(maxWidth: .infinity)
            .height(Constant.SearchBar.height)
            .padding(.horizontal, 10)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(5)
            .onTapGesture {
                viewModel.navigationType = .search
            }

            Button(
                action: {
                    viewModel.navigationType = .notifications
                },
                label: {
                    ImageAssets.icNotifications.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .height(24)
                }
            )
            AvatarView(url: viewModel.avatarURL, size: .init(width: 24, height: 24))
                .onTapGesture {
                    viewModel.navigationType = .setting
                }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .background(themeManager.theme.primary200)
        .cornerRadius([.bottomTrailing, .bottomLeading], 13)
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        VStack(spacing: 25) {
            VStack {
//                Text(L10n.friendEarnPointsByReferrals)
//                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
//                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)

                Button(action: {
                    viewModel.navigationTypeAction.send(.inviteFriends)
                }, label: {
                    HStack {
                        Text(L10n.inviteToGetBenefits)
                            .lineLimit(1)
                        ImageAssets.icArrowRight.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 35)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    .background(themeManager.theme.primary100)
                    .cornerRadius(11)
                })
                .padding(.horizontal, 16)
            }

            VStack(spacing: 0) {
//                HStack {
//                    Text(L10n.friendList)
//                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
//                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    ImageAssets.icSearch.swiftUIImage
//                        .resizable()
//                        .frame(.init(width: 24, height: 24))
//                        .scaledToFit()
//                        .onPress {
//                            viewModel.navigationTypeAction.send(.search)
//                        }
//                }
//                .padding(.top, 22)
//                .padding(.horizontal, 16)

                ContactListView(
                    viewModel: ContactListViewModel(
                        isMultiSelectionEnabled: false,
                        isSearchHidden: true,
                        isShowNotification: true,
                        contactListUseCases: ContactListUseCasesImpl(),
                        getAllUserAction: { users in
                            viewModel.users = users
                        }
                    ),
                    title: L10n.friendList,
                    selectedUsers: $viewModel.selectedUsers,
                    selectUserAction: { user in
                        viewModel.navigationTypeAction.send(.friendDetail(user))
                    }
                )
            }
            .background(ColorAssets.neutralLight.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildFloatButton() -> some View {
        Button(
            action: {
                viewModel.navigationTypeAction.send(.addFriends)
            },
            label: {
                Label {
                    Text(L10n.addFriendTitle)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                } icon: {
                    ImageAssets.icAddPerson.swiftUIImage
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        )
        .padding(12)
        .background(ColorAssets.secondaryYellow300.swiftUIColor)
        .cornerRadius(16, style: .circular)
        .shadow(color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.12), radius: 10, x: 0, y: 12)
        .padding(16)
    }

    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { item in
                switch item.wrappedValue {
                case .addFriends:
                    AddFriendsHomeView(
                        viewModel: AddFriendsHomeViewModel(
                            delegate: viewModel
                        )
                    )
                case .search:
                    AddFriendContactListView(
                        viewModel: AddFriendContactListViewModel(type: .friend)
                    )
                case let .friendDetail(user):
                    FriendDetailView(
                        viewModel: FriendDetailViewModel(user: user)
                    )
                case .setting:
                    ProfileSettingView(
                        viewModel: ProfileSettingViewModel(
                            delegate: viewModel
                        )
                    )
                case .inviteFriends:
                    ReferralView(viewModel: ReferralViewModel())
                case .notifications:
                    FriendNotificationView(viewModel: FriendNotificationViewModel())
                }
            },
            label: {
                EmptyView()
            }
        )
        .isDetailLink(false)
    }
}

// MARK: - HomeFriendView_Previews

struct HomeFriendView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFriendView(viewModel: HomeFriendViewModel())
    }
}
