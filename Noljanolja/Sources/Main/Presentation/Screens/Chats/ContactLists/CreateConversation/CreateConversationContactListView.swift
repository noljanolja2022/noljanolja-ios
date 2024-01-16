//
//  CreateConversationContactListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUINavigation

// MARK: - CreateConversationContactListView

struct CreateConversationContactListView<ViewModel: CreateConversationContactListViewModel>: View {
    // MARK: Dependencies

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @State private var selectedUsers = [User]()

    private var isCreateConversationEnabled: Bool {
        !selectedUsers.isEmpty
    }

    var body: some View {
        buildBodyView()
            .navigationBar(
                backButtonTitle: "",
                isPresent: false,
                presentationMode: presentationMode,
                middle: { middle },
                trailing: { trailing }
            )
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLink()
        }
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: {
                    switch viewModel.createConversationType {
                    case .single: return false
                    case .group: return true
                    case .unknown: return false
                    }
                }(),
                contactListUseCases: ContactListUseCasesImpl()
            ),
            title: L10n.commonFriends,
            selectedUsers: $selectedUsers,
            selectUserAction: { _ in
                switch viewModel.createConversationType {
                case .single:
                    viewModel.action.send(selectedUsers)
                case .group, .unknown:
                    return
                }
            }, emptyListView: {
                buildEmptyCreateGroup()
            }
        )
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
    }

    @ViewBuilder
    private func buildEmptyCreateGroup() -> some View {
        VStack(spacing: 10) {
            ImageAssets.icEmptyFriendList.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 247)
            Text(L10n.yourFriendListEmpty)
                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                .multilineTextAlignment(.center)

            Button(
                action: {
                    viewModel.navigationType = .addFriends
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
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    @ViewBuilder
    private var middle: some View {
        Text(
            { () -> String in
                switch viewModel.createConversationType {
                case .single, .unknown:
                    return L10n.contactsTitleNormal
                case .group:
                    return L10n.contactsTitleGroup
                }
            }()
        )
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }

    @ViewBuilder
    private var trailing: some View {
        ZStack {
            switch viewModel.createConversationType {
            case .single, .unknown:
                EmptyView()
            case .group:
                Button(L10n.commonAgree) {
                    viewModel.action.send(selectedUsers)
                }
                .dynamicFont(.systemFont(ofSize: 16))
                .foregroundColor(
                    isCreateConversationEnabled
                        ? ColorAssets.systemBlue100.swiftUIColor
                        : ColorAssets.neutralGrey.swiftUIColor
                )
                .disabled(!isCreateConversationEnabled)
            }
        }
    }
}

extension CreateConversationContactListView {
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
                }
            },
            label: {
                EmptyView()
            }
        )
        .isDetailLink(false)
    }
}

// MARK: - CreateConversationContactListView_Previews

struct CreateConversationContactListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateConversationContactListView(
            viewModel: CreateConversationContactListViewModel(
                createConversationType: .single
            )
        )
    }
}
