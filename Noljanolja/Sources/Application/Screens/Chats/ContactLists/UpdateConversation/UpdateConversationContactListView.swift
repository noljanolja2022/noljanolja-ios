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
                    Text("Select Contact")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        Button("Agree") {
                            viewModel.actionSubject.send(selectedUsers)
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
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .progressHUB(isActive: $viewModel.isProgressHUDShowing)
            .onReceive(viewModel.closeSubject) {
                presentationMode.wrappedValue.dismiss()
            }
            .progressHUB(isActive: $viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: true,
                contactListUseCase: UpdateConversationContactListUseCase(
                    conversation: viewModel.conversation
                )
            ),
            selectedUsers: $selectedUsers,
            selectUserAction: { _ in }
        )
    }
}

// MARK: - UpdateConversationContactListView_Previews

struct UpdateConversationContactListView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateConversationContactListView(
            viewModel: UpdateConversationContactListViewModel(
                conversation: Conversation(
                    id: 0,
                    title: nil,
                    creator: User(
                        id: "",
                        name: nil,
                        avatar: nil,
                        pushToken: nil,
                        phone: nil,
                        email: nil,
                        isEmailVerified: false,
                        dob: nil,
                        gender: nil,
                        preferences: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    ),
                    admin: User(
                        id: "",
                        name: nil,
                        avatar: nil,
                        pushToken: nil,
                        phone: nil,
                        email: nil,
                        isEmailVerified: false,
                        dob: nil,
                        gender: nil,
                        preferences: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    ),
                    type: .single,
                    messages: [],
                    participants: [],
                    createdAt: Date(),
                    updatedAt: Date()
                )
            )
        )
    }
}
