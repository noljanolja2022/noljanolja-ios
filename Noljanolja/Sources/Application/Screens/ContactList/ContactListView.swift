//
//  ContactListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SwiftUI
import SwiftUINavigation

// MARK: - ContactListView

struct ContactListView<ViewModel: ContactListViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState
    
    init(viewModel: ViewModel = ContactListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildBodyView()
            .onChange(of: viewModel.state.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .onAppear { viewModel.send(.loadData) }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select Contact")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 16) {
            SearchView(placeholder: "Search friend...", text: $viewModel.state.searchString)
                .padding(.horizontal, 16)
            buildContentView()
                .statefull(
                    state: $viewModel.state.viewState,
                    isEmpty: { viewModel.state.users.isEmpty },
                    loading: buildLoadingView,
                    empty: buildEmptyView,
                    error: buildErrorView
                )
        }
        .padding(.top, 12)
    }

    private func buildContentView() -> some View {
        ListView {
            ForEach(viewModel.state.users, id: \.id) { user in
                ContactItemView(name: user.name)
                    .background(Color.white)
                    .onTapGesture { viewModel.send(.createConversation(user)) }
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
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
        IfLet($viewModel.state.error) {
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
                                viewModel.send(.requestContactsPermission)
                            } else {
                                viewModel.send(.openAppSetting)
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
        ContactListView()
    }
}
