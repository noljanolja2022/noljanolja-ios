//
//  AddFriendContactListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/06/2023.
//
//

import SwiftUI

// MARK: - AddFriendContactListView

struct AddFriendContactListView<ViewModel: AddFriendContactListViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
            .navigationBarHidden(true)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ZStack {
            buildMainView()
            buildNavigationLink()
        }
    }

    private func buildMainView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: false,
                isBackButtonHidden: false,
                contactListUseCases: ContactListUseCasesImpl()
            ),
            selectedUsers: .constant([]),
            selectUserAction: { viewModel.action.send($0) }
        )
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
    }

    @ViewBuilder
    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { buildNavigationDestinationView($0) },
            label: {}
        )
    }
}

extension AddFriendContactListView {
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<AddFriendContactListNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .chat(conversationId):
            ChatView(
                viewModel: ChatViewModel(
                    conversationID: conversationId
                )
            )
        case let .detail(user):
            FriendDetailView(viewModel: FriendDetailViewModel(user: user))
        }
    }
}

// MARK: - AddFriendContactListView_Previews

struct AddFriendContactListView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendContactListView(viewModel: AddFriendContactListViewModel(type: .chat))
    }
}
