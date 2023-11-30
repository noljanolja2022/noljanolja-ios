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

    var body: some View {
        contentView()
    }

    @ViewBuilder
    private func contentView() -> some View {
        VideoDetailRootContainerView(
            content: {
                ZStack(alignment: .bottomTrailing) {
                    VStack {
                        buildHeaderView()
                        buildBodyView()
                    }
                    buildFloatButton()
                    buildNavigationLink()
                }
            },
            viewModel: VideoDetailRootContainerViewModel()
        )
    }

    @ViewBuilder
    private func buildHeaderView() -> some View {
        HeaderCommonView(
            notificationAction: {},
            settingAction: { viewModel.navigationTypeAction.send(.setting) }
        ) {
            ZStack {
                Text("Earn Points\n")
                    + Text("By Refer")
            }
            .dynamicFont(.systemFont(ofSize: 32, weight: .bold))
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        VStack(spacing: 25) {
            Button(action: {
                viewModel.navigationTypeAction.send(.inviteFriends)
            }, label: {
                HStack {
                    Text(L10n.inviteToGetBenefits)
                    ImageAssets.icArrowRight.swiftUIImage
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(maxWidth: .infinity)
                .height(52)
                .padding(.horizontal, 35)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .foregroundColor(ColorAssets.secondaryYellow200.swiftUIColor)
                .background(ColorAssets.neutralDarkGrey.swiftUIColor)
                .cornerRadius(11)
            })
            .padding(.horizontal, 16)

            VStack(spacing: 0) {
                HStack {
                    Text(L10n.friendList)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ImageAssets.icSearch.swiftUIImage
                        .resizable()
                        .frame(.init(width: 24, height: 24))
                        .scaledToFit()
                        .onPress {
                            viewModel.navigationTypeAction.send(.search)
                        }
                }
                .padding(.top, 22)
                .padding(.horizontal, 16)

                ContactListView(
                    viewModel: ContactListViewModel(
                        isMultiSelectionEnabled: false,
                        isSearchHidden: true,
                        contactListUseCases: ContactListUseCasesImpl()
                    ),
                    selectedUsers: $viewModel.selectedUsers,
                    selectUserAction: { user in
                        viewModel.navigationTypeAction.send(.friendDetail(user))
                    }
                )
            }
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius([.topLeading, .topTrailing], 25)
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
                        viewModel: AddFriendContactListViewModel()
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
