//
//  HomeFriendView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/09/2023.
//
//

import SwiftUI

// MARK: - HomeFriendView

struct HomeFriendView<ViewModel: HomeFriendViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: false,
                contactListUseCase: ContactListUseCaseImpl()
            ),
            selectedUsers: $viewModel.selectedUsers,
            selectUserAction: { _ in }
        )
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
    }
}

// MARK: - HomeFriendView_Previews

struct HomeFriendView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFriendView(viewModel: HomeFriendViewModel())
    }
}