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

    @StateObject var viewModel: ViewModel
    var createConversationType: ConversationType

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState
    @State private var selectedUsers = [User]()
    private var isCreateConversationEnabled: Bool {
        !selectedUsers.isEmpty
    }

    var body: some View {
        buildBodyView()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select Contact")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        switch createConversationType {
                        case .single, .unknown:
                            EmptyView()
                        case .group:
                            Button("Agree") {
                                viewModel.createConversationAction.send(
                                    (createConversationType, selectedUsers)
                                )
                            }
                            .font(.system(size: 16))
                            .foregroundColor(
                                isCreateConversationEnabled
                                    ? ColorAssets.neutralDarkGrey.swiftUIColor
                                    : ColorAssets.neutralGrey.swiftUIColor
                            )
                            .disabled(!isCreateConversationEnabled)
                        }
                    }
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: {
                    switch createConversationType {
                    case .single: return false
                    case .group: return true
                    case .unknown: return false
                    }
                }(),
                contactListUseCase: CreateConversationContactListUseCase()
            ),
            selectedUsers: $selectedUsers,
            selectUserAction: { _ in
                switch createConversationType {
                case .single:
                    viewModel.createConversationAction.send(
                        (createConversationType, selectedUsers)
                    )
                case .group, .unknown:
                    return
                }
            }
        )
    }
}

// MARK: - CreateConversationContactListView_Previews

struct CreateConversationContactListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateConversationContactListView(
            viewModel: CreateConversationContactListViewModel(),
            createConversationType: .single
        )
    }
}
