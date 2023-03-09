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
        buildContentView()
            .statefull(
                state: $viewModel.state.viewState,
                isEmpty: { viewModel.state.users.isEmpty },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
            .onChange(of: viewModel.state.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .onAppear {
                viewModel.send(.loadData)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select Contact")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                        .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                }
            }
    }

    private func buildContentView() -> some View {
        VStack {
            HStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                    TextField("Search", text: $viewModel.state.searchString)
                        .keyboardType(.phonePad)
                        .textFieldStyle(FullSizeTappableTextFieldStyle())
                        .frame(height: 32)
                        .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                    if !viewModel.state.searchString.isEmpty {
                        Button(
                            action: {
                                viewModel.state.searchString = ""
                            },
                            label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                            }
                        )
                    }
                }
                .padding(.leading, 12)
                .padding(.trailing, 8)
                .frame(height: 44)
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)

            List {
                ForEach(viewModel.state.users, id: \.id) { user in
                    ContactItemView(name: user.name)
                        .background(Color.white)
                        .onTapGesture { viewModel.send(.createConversation(user)) }
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top, 12)
    }

    private func buildLoadingView() -> some View {
        Text("Loading...")
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
                                .font(.system(size: 16).bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        }
                    )
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(26)
                }
                .padding(16)
            } else {
                Text("Error")
            }
        }
    }

    private func buildEmptyView() -> some View {
        Text("Empty")
    }
}

// MARK: - ContactListView_Previews

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
