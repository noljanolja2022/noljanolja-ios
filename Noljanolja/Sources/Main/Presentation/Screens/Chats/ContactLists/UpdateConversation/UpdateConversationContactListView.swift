//
//  UpdateConversationContactListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/04/2023.
//
//

import SwiftUI

// MARK: - UpdateConversationContactListView

struct UpdateConversationContactListView<ViewModel: UpdateConversationContactListViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    @State private var selectedUsers = [User]()
    
    private var isCreateConversationEnabled: Bool {
        !selectedUsers.isEmpty
    }

    var body: some View {
        buildBodyView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.contactsTitleAddMemmber)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        Button(L10n.commonAgree) {
                            viewModel.action.send(selectedUsers)
                        }
                        .dynamicFont(.systemFont(ofSize: 16))
                        .foregroundColor(
                            isCreateConversationEnabled
                                ? ColorAssets.neutralDarkGrey.swiftUIColor
                                : ColorAssets.neutralGrey.swiftUIColor
                        )
                        .disabled(!isCreateConversationEnabled)
                    }
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .onReceive(viewModel.closeAction) {
                presentationMode.wrappedValue.dismiss()
            }
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: true,
                contactListUseCases: UpdateConversationContactListUseCases(
                    conversation: viewModel.conversation
                )
            ),
            selectedUsers: $selectedUsers,
            selectUserAction: { _ in }
        )
    }
}
