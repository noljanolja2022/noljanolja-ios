//
//  ContactListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUINavigation

// MARK: - ContactListView

struct ContactListView<ViewModel: ContactListViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    var createConversationType: ConversationType

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    var body: some View {
        buildBodyView()
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .onAppear { viewModel.loadDataTrigger.send() }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select Contact")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Agree") {
                        viewModel.createConversationTrigger.send(createConversationType)
                    }
                    .font(.system(size: 16))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                }
            }
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 16) {
            SearchView(placeholder: "Search by name/Phone number", text: $viewModel.searchString)
                .padding(.horizontal, 16)
            buildSelectedUsers()
            buildContentView()
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.users.isEmpty },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
        .padding(.top, 12)
    }

    @ViewBuilder
    private func buildSelectedUsers() -> some View {
        if createConversationType == .group, !viewModel.selectedUsers.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.selectedUsers, id: \.id) { user in
                        ZStack(alignment: .topTrailing) {
                            WebImage(url: URL(string: user.avatar))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .background(ColorAssets.neutralGrey.swiftUIColor)
                                .cornerRadius(14)
                                .padding(.trailing, 6)
                            Button(
                                action: {
                                    viewModel.selectUserSubject.send((createConversationType, user))
                                },
                                label: {
                                    ImageAssets.icClose.swiftUIImage
                                        .resizable()
                                        .padding(6)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(ColorAssets.white.swiftUIColor)
                                        .background(ColorAssets.neutralDarkGrey.swiftUIColor)
                                        .cornerRadius(10)
                                }
                            )
                        }
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

    private func buildContentView() -> some View {
        ListView {
            Text("Friends")
                .font(Font.system(size: 16, weight: .bold))
                .padding(.horizontal, 16)
            ForEach(viewModel.users, id: \.id) { user in
                ContactItemView(
                    user: user,
                    isSelected: {
                        switch createConversationType {
                        case .single: return nil
                        case .group: return viewModel.selectedUsers.contains(user)
                        }
                    }()
                )
                .onTapGesture {
                    viewModel.selectUserSubject.send((createConversationType, user))
                }
            }
        }
    }

    private func buildEmptyView() -> some View {
        Text("Can't found friend")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        IfLet($viewModel.error) {
            if let contactsError = $0.wrappedValue as? ContactsError,
               contactsError.isPermissionError {
                VStack(spacing: 16) {
                    Text("Permission")
                        .font(.system(size: 20).bold())
                    Text("To help you message friends and family on Noja Noja, allow Noja Noja access to your contacts")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                    Button(
                        action: {
                            if contactsError == .permissionNotDetermined {
                                viewModel.requestContactsPermissionTrigger.send()
                            } else {
                                guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        },
                        label: {
                            Text("Accept")
                                .font(.system(size: 16, weight: .bold))
                                .frame(height: 40)
                                .padding(.horizontal, 24)
                        }
                    )
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .background(ColorAssets.primaryYellowMain.swiftUIColor)
                    .cornerRadius(10)
                }
                .padding(16)
            } else {
                Text("Error")
                    .font(.system(size: 16, weight: .bold))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - ContactListView_Previews

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView(
            viewModel: ContactListViewModel(),
            createConversationType: .single
        )
    }
}
