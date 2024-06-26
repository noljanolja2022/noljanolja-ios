//
//  FindUsersResultView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/06/2023.
//
//

import SwiftUI

// MARK: - FindUsersResultView

struct FindUsersResultView<ViewModel: FindUsersResultViewModel>: View {
    // MARK: Dependencies

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
            .navigationBar(title: L10n.addFriendTitle, backButtonTitle: "", presentationMode: presentationMode, trailing: {})
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildMainView()
            buildNavigationLink()
        }
    }

    private func buildMainView() -> some View {
        buildContentView()
    }

    private func buildContentView() -> some View {
        ListView {
            ForEach(viewModel.users.indices, id: \.self) { index in
                let user = viewModel.users[index]
                FindUserResultItemView(
                    model: user,
                    chatAction: {
                        viewModel.addFriendAction.send(user)
                    }
                )
            }
        }
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

extension FindUsersResultView {
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<FindUsersResultNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .chat(conversationId):
            ChatView(
                viewModel: ChatViewModel(
                    conversationID: conversationId
                )
            )
        }
    }
}

// MARK: - FindUsersResultView_Previews

struct FindUsersResultView_Previews: PreviewProvider {
    static var previews: some View {
        FindUsersResultView(viewModel: FindUsersResultViewModel(users: []))
    }
}
