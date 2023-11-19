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

struct ContactListView<EndingView: View, ViewModel: ContactListViewModel>: View {
    // MARK: Dependencies

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @Binding var selectedUsers: [User]
    var selectUserAction: ((User) -> Void)?
    private let endingView: EndingView

    public init(viewModel: ViewModel,
                selectedUsers: Binding<[User]>,
                selectUserAction: ((User) -> Void)? = nil,
                @ViewBuilder endingView: () -> EndingView = { EmptyView() }) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _selectedUsers = selectedUsers
        self.selectUserAction = selectUserAction
        self.endingView = endingView()
    }

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildSearchView()
            buildMainView()
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
    }

    @ViewBuilder
    private func buildSearchView() -> some View {
        if !viewModel.isSearchHidden {
            HStack(spacing: 10) {
                if !viewModel.isBackButtonHidden {
                    Button(
                        action: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: ImageAssets.icBack.swiftUIImage
                            .frame(width: 24, height: 24)
                    )
                }

                SearchView(placeholder: L10n.contactSearchHint, text: $viewModel.searchString)
                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 15)
        }
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        VStack(spacing: 16) {
            buildSelectedUsersView()

            switch viewModel.axis {
            case .vertical:
                buildVerticalListView()
            case .horizontal:
                buildHorizontalListView()
            }
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.users.isEmpty },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
    }
}

extension ContactListView {
    @ViewBuilder
    private func buildVerticalListView() -> some View {
        ListView {
            VStack(spacing: 4) {
                ForEach(viewModel.users, id: \.id) { user in
                    VerticalContactItemView(
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
                endingView
            }
            .background(ColorAssets.neutralLight.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildHorizontalListView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.users, id: \.id) { user in
                    HorizontalContactItemView(
                        user: user
                    )
                    .background(ColorAssets.neutralLight.swiftUIColor) // TODO: TO enable tap item
                    .onTapGesture {
                        selectUser(user)
                        selectUserAction?(user)
                    }
                }
                endingView
            }
            .background(ColorAssets.neutralLight.swiftUIColor)
        }
    }
}

extension ContactListView {
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
}

extension ContactListView {
    @ViewBuilder
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(
                maxWidth: .infinity,
                maxHeight: {
                    switch viewModel.axis {
                    case .horizontal: return nil
                    case .vertical: return .infinity
                    }
                }()
            )
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    @ViewBuilder
    private func buildEmptyView() -> some View {
        Text(L10n.contactsNotFound)
            .frame(
                maxWidth: .infinity,
                maxHeight: {
                    switch viewModel.axis {
                    case .horizontal: return nil
                    case .vertical: return .infinity
                    }
                }()
            )
            .background(ColorAssets.neutralLight.swiftUIColor)
            .foregroundColor(.red)
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
            .frame(
                maxWidth: .infinity,
                maxHeight: {
                    switch viewModel.axis {
                    case .horizontal: return nil
                    case .vertical: return .infinity
                    }
                }()
            )
            .background(ColorAssets.neutralLight.swiftUIColor)
        } else {
            Text("\(L10n.commonErrorTitle)\n\(viewModel.error?.localizedDescription ?? "")")
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .frame(
                    maxWidth: .infinity,
                    maxHeight: {
                        switch viewModel.axis {
                        case .horizontal: return nil
                        case .vertical: return .infinity
                        }
                    }()
                )
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
