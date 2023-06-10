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
        buildMainView()
    }

    private func buildMainView() -> some View {
        buildContentView()
    }

    private func buildContentView() -> some View {
        ListView {
            ForEach(viewModel.users.indices, id: \.self) { index in
                FindUserResultItemView(model: viewModel.users[index])
            }
        }
    }
}

// MARK: - FindUsersResultView_Previews

struct FindUsersResultView_Previews: PreviewProvider {
    static var previews: some View {
        FindUsersResultView(viewModel: FindUsersResultViewModel(users: []))
    }
}
