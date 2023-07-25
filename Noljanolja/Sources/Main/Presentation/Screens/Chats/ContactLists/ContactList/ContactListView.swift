//
//  ContactListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ContactListView

struct ContactListView<ViewModel: ContactListViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @Binding var selectedUsers: [User]
    var selectUserAction: ((User) -> Void)?

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        buildMainView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        VStack(spacing: 0) {
            SearchView(placeholder: L10n.contactSearchHint, text: $viewModel.searchString)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 20)
            buildContentView()
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        VStack(spacing: 16) {
            buildSelectedUsersView()
            buildListView()
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.users.isEmpty },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
    }

    @ViewBuilder
    private func buildSelectedUsersView() -> some View {
        if viewModel.isMultiSelectionEnabled, !selectedUsers.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(selectedUsers, id: \.id) { user in
                        SelectedContactItemView(
                            user: user,
                            action: { selectUser(user) }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
            }
            .frame(height: 50)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func buildListView() -> some View {
        ListView {
            VStack(spacing: 0) {
                Text(L10n.commonFriends)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .semibold))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(viewModel.users, id: \.id) { user in
                    ContactItemView(
                        user: user,
                        isSelected: {
                            if viewModel.isMultiSelectionEnabled {
                                return selectedUsers.contains(user)
                            } else {
                                return nil
                            }
                        }()
                    )
                    .background(ColorAssets.neutralLight.swiftUIColor) // TODO: TO enable tap item
                    .onTapGesture {
                        selectUser(user)
                        selectUserAction?(user)
                    }
                }
            }
            .background(ColorAssets.neutralLight.swiftUIColor)
        }
    }
}

extension ContactListView {
    private func selectUser(_ user: User) {
        if viewModel.isMultiSelectionEnabled {
            if let user = selectedUsers.first(where: { $0.id == user.id }) {
                selectedUsers = selectedUsers.removeAll(user)
            } else {
                selectedUsers.append(user)
            }
        } else {
            selectedUsers = [user]
        }
    }
}

extension ContactListView {
    @ViewBuilder
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    @ViewBuilder
    private func buildEmptyView() -> some View {
        Text(L10n.contactsNotFound)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func buildErrorView() -> some View {
        if let error = viewModel.error,
           let contactsError = error as? ContactsError,
           contactsError.isPermissionError {
            VStack(spacing: 16) {
                Text(L10n.permission)
                    .dynamicFont(.systemFont(ofSize: 20, weight: .bold))
                Text(L10n.permissionContactsDescription)
                    .dynamicFont(.systemFont(ofSize: 16))
                    .multilineTextAlignment(.center)
                Button(
                    action: {
                        if contactsError == .permissionNotDetermined {
                            viewModel.requestPermissionSubject.send()
                        } else {
                            guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    },
                    label: {
                        Text(L10n.permissionAccept)
                            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                            .frame(height: 40)
                            .padding(.horizontal, 24)
                    }
                )
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.primaryGreen200.swiftUIColor)
                .cornerRadius(10)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Text(L10n.commonErrorTitle)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - ContactListView_Previews

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: true,
                contactListUseCase: ContactListUseCaseImpl()
            ),
            selectedUsers: .constant([])
        )
    }
}
