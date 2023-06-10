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

    @StateObject var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    var body: some View {
        buildBodyView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.addFriendsTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
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
